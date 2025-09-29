import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:crypto_portfolio_tracker/core/services/base_api_services.dart';
import 'package:crypto_portfolio_tracker/shared/app_logger.dart';
import 'package:crypto_portfolio_tracker/shared/internet_connection_helper.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_view_utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NetworkAPIServices extends BaseApiServices {
  NetworkAPIServices._internal();
  static final NetworkAPIServices _instance = NetworkAPIServices._internal();
  factory NetworkAPIServices() => _instance;
  final InternetConnectionHelper _internetHelper =
      Get.put<InternetConnectionHelper>(InternetConnectionHelper());

  @override
  Future<dynamic> generateGetAPIResponse(String uri) async {
    if (!_internetHelper.isInternetConnected.value) {
      return _handleNoInternetError();
    }
    try {
      AppLogger.showInfoLogs('GET: $uri');
      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse(uri), headers: headers)
          .timeout(const Duration(seconds: 15));
      return _parseApiResponse(response);
    } on TimeoutException catch (_) {
      AppLogger.showErrorLogs('Request timed out');
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, "Request timed out");
      }
      return {'error': 'Request timed out'};
    } on SocketException catch (_) {
      AppLogger.showErrorLogs('No internet connection');
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(
            Get.context!, StringConstants.noInternetSubText);
      }
      return {'error': 'No internet connection'};
    } catch (e) {
      AppLogger.showErrorLogs('Unexpected error: $e');
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Unexpected error occurred');
      }
      return {'error': 'Unexpected error occurred'};
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    return {"Content-Type": "application/json"};
  }

  dynamic _parseApiResponse(http.Response response) {
    AppLogger.showInfoLogs("Response: ${response.statusCode} => ${response.body}");
    try {
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
          if (Get.context != null) {
            AppViewUtils.showTopSnackbar(
                Get.context!, 'Error: ${response.statusCode}');
          }
          return jsonDecode(response.body);
        case 401:
          _handleUnAuthorizedError();
          return {'error': 'Unauthorized'};
        default:
          AppLogger.showErrorLogs("Unhandled status code ${response.statusCode}");
          if (Get.context != null) {
            AppViewUtils.showTopSnackbar(
                Get.context!, 'Unhandled status code ${response.statusCode}');
          }
          return {'error': 'Unhandled status code ${response.statusCode}'};
      }
    } catch (e) {
      AppLogger.showErrorLogs('Failed to parse response: $e');
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Failed to parse response');
      }
      return {'error': 'Failed to parse response'};
    }
  }

  dynamic _handleNoInternetError() {
    AppLogger.showErrorLogs('No internet connection.');
    if (Get.context != null) {
      AppViewUtils.showTopSnackbar(Get.context!, StringConstants.noInternetSubText);
    }
    return {'error': 'No internet connection'};
  }

  dynamic _handleUnAuthorizedError() {
    AppLogger.showErrorLogs('Token Expired');
    if (Get.context != null) {
      AppViewUtils.showTopSnackbar(Get.context!, 'Session expired. Please login again.');
    }
    return {'error': 'Token Expired'};
  }
}
