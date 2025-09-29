import 'dart:convert';
import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static final AppSharedPreferences customSharedPreferences =
      AppSharedPreferences._internal();

  SharedPreferences? _prefs;
  AppSharedPreferences._internal();
  static const _coinListKey = "coin_list";

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveValue<T>(String key, T value) async {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');

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
  }

  T? getValue<T>(String key) {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    if (T == String) {
      return _prefs!.getString(key) as T?;
    } else if (T == int) {
      return _prefs!.getInt(key) as T?;
    } else if (T == double) {
      return _prefs!.getDouble(key) as T?;
    } else if (T == bool) {
      return _prefs!.getBool(key) as T?;
    } else if (T == List<String>) {
      return _prefs!.getStringList(key) as T?;
    } else {
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as T;
    }
  }

  void removeValue(String key) {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    _prefs!.remove(key);
  }

  Future<void> clearSharedPreference() async {
    if (_prefs == null) throw Exception('SharedPreferences not initialized');
    await _prefs!.clear();
  }

  Future<void> saveCoinsToPortFolio(List<Coin> coins) async {
    final jsonList = coins.map((c) => c.toJson()).toList();
    await saveValue(_coinListKey, jsonEncode(jsonList));
  }

  Future<List<Coin>> loadCoinsFromPortFolio() async {
    final jsonStr =await  getValue<String>(_coinListKey);
    if (jsonStr == null) return [];
    final List decoded = jsonDecode(jsonStr);
    return decoded.map((e) => Coin.fromJson(e)).toList();
  }
}
