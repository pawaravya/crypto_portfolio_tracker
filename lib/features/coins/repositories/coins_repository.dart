import 'package:crypto_portfolio_tracker/core/constants/AppUrl.dart';
import 'package:crypto_portfolio_tracker/core/services/network_api_services.dart';
import 'package:flutter/material.dart';

class CoinsRepository {
  CoinsRepository._internal();
  NetworkAPIServices _networkAPIServices = NetworkAPIServices();
  static final CoinsRepository _instance = CoinsRepository._internal();

  factory CoinsRepository() => _instance;

  Future<dynamic> fetchAllCoins(BuildContext context) async {
    return await _networkAPIServices.generateGetAPIResponse(
      context,
      Appurl.getAllCoinsListUrl,
    );
  }
}
