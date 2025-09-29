import 'dart:ffi';

import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';
import 'package:crypto_portfolio_tracker/features/coins/repositories/coins_repository.dart';
import 'package:crypto_portfolio_tracker/shared/app_shared_preferences.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';

class CoinsController extends GetxController {
  var isLoading = false.obs;
  var error = "".obs; // nullable error message
  var allCoins = <Coin>[].obs;
  var coinsInPortFolio = <Coin>[].obs;
  CoinsRepository coinsRepository = CoinsRepository();

  late Trie trie; // For fast prefix search

  Future<void> fetchCoins() async {
    isLoading.value = true;
    error.value = "";
    try {
      coinsInPortFolio.value = await AppSharedPreferences
          .customSharedPreferences
          .loadCoinsFromPortFolio();
      final jsonData = await coinsRepository.fetchAllCoins();
      if (jsonData is List) {
        final List<Coin> fetchedCoins = jsonData
            .map((item) => Coin.fromJson(item as Map<String, dynamic>))
            .toList();
        allCoins.value = fetchedCoins;
        trie = Trie();
        for (var coin in fetchedCoins) {
          if (coin.name != null) trie.insert(coin.name!, coin);
          if (coin.symbol != null) trie.insert(coin.symbol!, coin);
        }
      } else {
        //TODO
      }
    } catch (e) {
      error.value = "Failed to fetch coins. Try again.";
    } finally {
      isLoading.value = false;
    }
  }

  List<Coin> searchCoins(String query) {
    if (query.isEmpty) return allCoins;
    return trie.searchPrefix(query);
  }
}

class TrieNode {
  Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
  Coin? coin;
}

class Trie {
  final TrieNode root = TrieNode();

  void insert(String word, Coin coin) {
    var node = root;
    for (var ch in word.toLowerCase().split('')) {
      node = node.children.putIfAbsent(ch, () => TrieNode());
    }
    node.isEndOfWord = true;
    node.coin = coin;
  }

  List<Coin> searchPrefix(String prefix) {
    var node = root;
    for (var ch in prefix.toLowerCase().split('')) {
      if (!node.children.containsKey(ch)) return [];
      node = node.children[ch]!;
    }
    return _collect(node);
  }

  List<Coin> _collect(TrieNode node) {
    List<Coin> results = [];
    if (node.isEndOfWord && node.coin != null) results.add(node.coin!);
    for (var child in node.children.values) {
      results.addAll(_collect(child));
    }
    return results;
  }
}
