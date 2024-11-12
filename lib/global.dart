import 'package:shared_preferences/shared_preferences.dart';

import 'model/user.dart';
import 'model/video.dart';

class Global {
  static int themeMode = 0;
  static String languageCode = "zh";

  static User self = User();

  static bool isLogin() {
    return self.id.isNotEmpty;
  }

  static List<List<Video>> cachedVideoList = [];
  static Map<String, List<Video>> cachedMapVideoList = {};
  static Map<String, List<String>> cachedMapDynamicList = {};
  static Map<String, List<String>> cachedMapUserList = {};
  static List<Video> cachedSearchVideoList = [];
}

class Storage {
  static storeThemeMode(int mode) {
    storeKeyInt("themeMode", mode);
  }

  static storeLanguageCode(String code) {
    storeKeyString("languageCode", code);
  }

  static Future<int?> getThemeMode() {
    return getKeyInt("themeMode");
  }

  static Future<String?> getLanguageCode() {
    return getKeyString("languageCode");
  }

  static storeKeyString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static storeKeyInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<String?> getKeyString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<int?> getKeyInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}
