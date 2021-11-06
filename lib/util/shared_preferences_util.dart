import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<SharedPreferences> getInstance() async {
    return SharedPreferences.getInstance();
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
