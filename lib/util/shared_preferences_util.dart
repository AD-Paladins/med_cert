import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<SharedPreferences> getInstance() async {
    return SharedPreferences.getInstance();
  }

  static Future<bool> storeJson(
      {required String key, required Map<String, dynamic> json}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString(key, jsonEncode(json));
    return result;
  }

  static Future<dynamic> getJson({required String key}) async {
    final prefs = await getInstance();
    String? userData = prefs.getString(key);

    if (userData != null) {
      dynamic jsonObject = jsonDecode(userData);
      return jsonObject;
    } else {
      return null;
    }
  }

  static storeString({required String key, required String value}) async {
    final prefs = await getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getString({required String key}) async {
    final prefs = await getInstance();
    return prefs.getString(key);
  }

  static storeInt({required String key, required int value}) async {
    final prefs = await getInstance();
    prefs.setInt(key, value);
  }

  static Future<int?> getInt({required String key}) async {
    final prefs = await getInstance();
    return prefs.getInt(key);
  }

  static deleteKey({required String key}) async {
    final prefs = await getInstance();
    prefs.remove(key);
  }

  static deleteAllKeys() async {
    final prefs = await getInstance();
    prefs.clear();
  }
}
