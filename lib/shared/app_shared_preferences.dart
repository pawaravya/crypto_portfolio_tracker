import 'dart:convert';
import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_view_utils.dart';

class AppSharedPreferences {
  static final AppSharedPreferences customSharedPreferences =
      AppSharedPreferences._internal();

  SharedPreferences? _prefs;
  AppSharedPreferences._internal();
  static const _coinListKey = "coin_list";

  Future<void> initPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Failed to initialize storage');
      }
    }
  }

  Future<void> saveValue<T>(String key, T value) async {
    if (_prefs == null) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Storage not initialized');
      }
      return;
    }
    try {
      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs!.setStringList(key, value);
      } else {
        await _prefs!.setString(key, jsonEncode(value));
      }
    } catch (e) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Failed to save value');
      }
    }
  }

  T? getValue<T>(String key) {
    if (_prefs == null) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Storage not initialized');
      }
      return null;
    }
    try {
      if (T == String) return _prefs!.getString(key) as T?;
      if (T == int) return _prefs!.getInt(key) as T?;
      if (T == double) return _prefs!.getDouble(key) as T?;
      if (T == bool) return _prefs!.getBool(key) as T?;
      if (T == List<String>) return _prefs!.getStringList(key) as T?;

      final jsonString = _prefs!.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as T;
    } catch (e) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Failed to read value');
      }
      return null;
    }
  }

  void removeValue(String key) {
    if (_prefs == null) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Storage not initialized');
      }
      return;
    }
    try {
      _prefs!.remove(key);
    } catch (e) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Failed to remove value');
      }
    }
  }

  Future<void> clearSharedPreference() async {
    if (_prefs == null) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Storage not initialized');
      }
      return;
    }
    try {
      await _prefs!.clear();
    } catch (e) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Failed to clear storage');
      }
    }
  }

  Future<void> saveCoinsToPortFolio(List<Coin> coins) async {
    try {
      final jsonList = coins.map((c) => c.toJson()).toList();
      await saveValue(_coinListKey, jsonEncode(jsonList));
    } catch (e) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Failed to save coins');
      }
    }
  }

  Future<List<Coin>> loadCoinsFromPortFolio() async {
    try {
      final jsonStr = await getValue<String>(_coinListKey);
      if (jsonStr == null) return [];
      final List decoded = jsonDecode(jsonStr);
      return decoded.map((e) => Coin.fromJson(e)).toList();
    } catch (e) {
      if (Get.context != null) {
        AppViewUtils.showTopSnackbar(Get.context!, 'Failed to load coins');
      }
      return [];
    }
  }
}
