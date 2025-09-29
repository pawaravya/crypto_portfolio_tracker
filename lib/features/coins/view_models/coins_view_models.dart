
import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';
import 'package:crypto_portfolio_tracker/features/coins/repositories/coins_repository.dart';
import 'package:crypto_portfolio_tracker/features/coins/view_models/trienode.dart';
import 'package:crypto_portfolio_tracker/shared/app_logger.dart';
import 'package:crypto_portfolio_tracker/shared/app_shared_preferences.dart';
import 'package:get/get.dart';


class CoinsController extends GetxController {
  var isLoading = false.obs;
  var error = "".obs; 
  var allCoins = <Coin>[].obs;
  var coinsInPortFolio = <Coin>[].obs;
  CoinsRepository coinsRepository = CoinsRepository();
  var selectedCoins = <Coin>[].obs;
  var isPrizesLoading = false.obs;
  late Trie trie; 

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
      error.value = "Unexpected data format from server.";
      AppLogger.showErrorLogs("fetchCoins: Invalid response format");
    }
  } catch (e, stack) {
    error.value = "Failed to fetch coins. Please try again.";
    AppLogger.showErrorLogs("fetchCoins Exception: $e\n$stack");
  } finally {
    isLoading.value = false;
  }
}

Future<void> fetchPrices() async {
  if (coinsInPortFolio.isEmpty) return;

  isPrizesLoading.value = true;
  error.value = "";
  try {
    final jsonData = await coinsRepository.fetchPrizesForCoin(coinsInPortFolio);

    if (jsonData is Map) {
      for (var coin in coinsInPortFolio) {
        if (jsonData.containsKey(coin.id)) {
          final priceData = jsonData[coin.id]?["usd"];
          coin.price = (priceData is num) ? priceData.toDouble() : 0.0;
        } else {
          coin.price = 0.0; 
        }
      }
      coinsInPortFolio.refresh(); 
    } else {
      error.value = "Unexpected price data format from server.";
      AppLogger.showErrorLogs("fetchPrices: Invalid response format");
    }
  } catch (e, stack) {
    error.value = "Failed to fetch prices. Please try again.";
    AppLogger.showErrorLogs("fetchPrices Exception: $e\n$stack");
  } finally {
    isPrizesLoading.value = false;
  }
}


  Future<void> addToSelection(Coin coin) async {
    final index = selectedCoins.indexWhere((c) => c.id == coin.id);

    if (index != -1) {
      selectedCoins[index] = coin;
    }
  }

  Future<void> removeFromPortfolio(Coin coin) async {
    coinsInPortFolio.remove(coin);
    await AppSharedPreferences.customSharedPreferences.saveCoinsToPortFolio(
      coinsInPortFolio,
    );
  }

  void toggleSelection(Coin coin) {
    if (selectedCoins.contains(coin)) {
      selectedCoins.remove(coin);
    } else {
      selectedCoins.add(coin);
    }
    selectedCoins.refresh();
  }

  Future<void> saveSelection() async {
    for (var coin in selectedCoins) {
      if (coinsInPortFolio.isNotEmpty) {
        final index = coinsInPortFolio.indexWhere((c) => c.id == coin.id);

        if (index == -1) {
          coinsInPortFolio.add(coin);
        } else {
          coin.selectedQuantuty =
              (coin.selectedQuantuty ?? 0) +
              (coinsInPortFolio[index].selectedQuantuty ?? 0);
          coinsInPortFolio[index] = coin;
        }
      } else {
        coinsInPortFolio.add(coin);
      }

      await AppSharedPreferences.customSharedPreferences.saveCoinsToPortFolio(
        coinsInPortFolio,
      );
    }
    selectedCoins.clear();
  }

  List<Coin> searchCoins(String query) {
    if (query.isEmpty) return allCoins;
    return trie.searchPrefix(query);
  }
}
