import 'dart:async';
import 'dart:convert';

import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:crypto_portfolio_tracker/core/services/base_api_services.dart';
import 'package:crypto_portfolio_tracker/shared/app_logger.dart';
import 'package:crypto_portfolio_tracker/shared/internet_connection_helper.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_view_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NetworkAPIServices extends BaseApiServices {
  NetworkAPIServices._internal();
  static final NetworkAPIServices _instance = NetworkAPIServices._internal();
  factory NetworkAPIServices() => _instance;
  final InternetConnectionHelper _internetHelper =
      Get.put<InternetConnectionHelper>(InternetConnectionHelper());

  @override
  Future<dynamic> generateGetAPIResponse(
    BuildContext context,
    String uri,
  ) async {
    if (!_internetHelper.isInternetConnected.value) {
      return _handleNoInternetError(context);
    }
    try {
      AppLogger.showInfoLogs('GET: $uri');

      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse(uri), headers: headers)
          .timeout(const Duration(seconds: 15));

      return _parseApiResponse(response);
    } catch (e) {}
  }

  Future<Map<String, String>> _getHeaders() async {
    return {"Content-Type": "application/json"};
  }

  // Parse API response
  dynamic _parseApiResponse(http.Response response) {
    AppLogger.showInfoLogs(
      "Response: ${response.statusCode} => ${response.body}",
    );

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
      case 404:
      case 422:
      case 429:
      case 500:
      case 403:
        return jsonDecode(response.body);
      case 401:
        _handleUnAuthorizedError();
        return {'error': 'Unauthorized'};
      default:
        AppLogger.showErrorLogs("Unhandled status code ${response.statusCode}");
        return '';
    }
  }

  dynamic _handleNoInternetError(BuildContext context) {
    AppLogger.showErrorLogs('No internet connection.');
    AppViewUtils.showTopSnackbar(context, StringConstants.noInternetSubText);
    return {'error': 'No internet connection'};
  }

  dynamic _handleUnAuthorizedError() {
    AppLogger.showErrorLogs('Token Expired');
    return {'error': 'Token Expired'};
  }
}
