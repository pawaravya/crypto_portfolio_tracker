import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';

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
