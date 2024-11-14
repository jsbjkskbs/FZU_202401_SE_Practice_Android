import 'dart:convert';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/user.dart';
import 'model/video.dart';

part 'global.g.dart';

@JsonSerializable()
class AppPersistentData {
  int themeMode;
  String themeSelection;
  String languageCode;

  AppPersistentData(
      {required this.themeMode,
      required this.languageCode,
      required this.themeSelection});

  factory AppPersistentData.fromJson(Map<String, dynamic> json) =>
      _$AppPersistentDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppPersistentDataToJson(this);
}

class Global {
  static AppPersistentData appPersistentData = AppPersistentData(
      themeMode: 0, languageCode: "zh", themeSelection: FlexScheme.sakura.name);

  static User self = User();

  static bool isLogin() {
    return self.id.isNotEmpty;
  }

  static List<List<Video>> cachedVideoList = [];
  static Map<String, List<Video>> cachedMapVideoList = {};
  static Map<String, List<String>> cachedMapDynamicList = {};
  static Map<String, List<String>> cachedMapUserList = {};
  static List<Video> cachedSearchVideoList = [];

  static const List<String> categoryList = ["游戏", "知识", "生活", "军事", "影音", "新闻"];
}

class Storage {
  static storePersistentData(AppPersistentData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("appPersistentData", jsonEncode(data));
    debugPrint("Storage.storePersistentData: ${data.toJson()}");
  }

  static Future<AppPersistentData> getPersistentData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("appPersistentData");
    if (data != null) {
      debugPrint("Storage.getPersistentData: $data");
      return AppPersistentData.fromJson(jsonDecode(data));
    } else {
      debugPrint("Storage.getPersistentData: default");
      return AppPersistentData(
          themeMode: 0,
          languageCode: "zh",
          themeSelection: FlexScheme.sakura.name);
    }
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
