import 'package:crypto_portfolio_tracker/core/constants/AppUrl.dart';
import 'package:crypto_portfolio_tracker/core/services/network_api_services.dart';
import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';

class CoinsRepository {
  CoinsRepository._internal();
  NetworkAPIServices _networkAPIServices = NetworkAPIServices();
  static final CoinsRepository _instance = CoinsRepository._internal();

  factory CoinsRepository() => _instance;

  Future<dynamic> fetchAllCoins() async {
    return await _networkAPIServices.generateGetAPIResponse(
      Appurl.getAllCoinsListUrl,
    );
  }

  Future<dynamic> fetchPrizesForCoin(List<Coin> coinsList) async {
    final ids = coinsList.map((c) => c.id).join(",");
    return await _networkAPIServices.generateGetAPIResponse(
      "${Appurl.fetchPrizes}price?ids=$ids&vs_currencies=usd",
    );
  }
}
