import 'dart:async';

import 'package:e_commerse_app/shared/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get/get.dart';

class InternetConnectionHelper extends GetxController
    with WidgetsBindingObserver {
  RxBool isInternetConnected = true.obs;
  AppLifecycleState? lastState;
  Timer? debounceTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    checkInternetStatus();
  }

  @override
  void onClose() {
    AppLogger.showInfoLogs('InternetConnectionHelper disposed');
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed &&
        lastState == AppLifecycleState.paused) {
      isInternetConnected.value = true;
      AppLogger.showInfoLogs('App resumed, checking internet connection.');
      final isConnected =
          await InternetConnectionChecker.instance.hasConnection;
      if (isConnected) {
        isInternetConnected.value = true;
      } else {
        // Debounce "disconnected" status to avoid false positives
        debounceTimer?.cancel();
        debounceTimer = Timer(Duration(seconds: 2), () async {
          final stillDisconnected =
              await InternetConnectionChecker.instance.hasConnection;
          if (!stillDisconnected) {
            AppLogger.showErrorLogs('You are disconnected from the internet.');
            isInternetConnected.value = false;
          }
        });
      }
      lastState = null;
    }
    if (state == AppLifecycleState.paused) {
      lastState = state;
    }
  }

  Future<void> checkInternetStatus() async {
    InternetConnectionChecker.instance.onStatusChange.listen((
      InternetConnectionStatus status,
    ) {
      switch (status) {
        case InternetConnectionStatus.connected:
          AppLogger.showInfoLogs('Data connection is available.');
          isInternetConnected.value = true;
          debounceTimer?.cancel();
          break;
        case InternetConnectionStatus.disconnected:
          debounceTimer?.cancel(); // Cancel any existing timer
          debounceTimer = Timer(Duration(seconds: 2), () async {
            final isConnected =
                await InternetConnectionChecker.instance.hasConnection;
            if (!isConnected) {
              AppLogger.showErrorLogs(
                'You are disconnected from the internet.',
              );
              isInternetConnected.value = false;
            }
          });
          break;
        case InternetConnectionStatus.slow:
          AppLogger.showInfoLogs('Data connection is available.');
          isInternetConnected.value = true;
          debounceTimer?.cancel();
          break;
      }
    });
    final isConnected = await InternetConnectionChecker.instance.hasConnection;
    isInternetConnected.value = isConnected;
  }
}
