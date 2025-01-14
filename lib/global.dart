import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:fulifuli_app/model/activity.dart';
import 'package:fulifuli_app/model/comment.dart';
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
  User? user;

  AppPersistentData({
    required this.themeMode,
    required this.languageCode,
    required this.themeSelection,
    this.user,
  });

  factory AppPersistentData.fromJson(Map<String, dynamic> json) => _$AppPersistentDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppPersistentDataToJson(this);

  AppPersistentData copyWith({
    int? themeMode,
    String? themeSelection,
    String? languageCode,
    User? user,
  }) {
    return AppPersistentData(
      themeMode: themeMode ?? this.themeMode,
      themeSelection: themeSelection ?? this.themeSelection,
      languageCode: languageCode ?? this.languageCode,
      user: user ?? this.user,
    );
  }
}

class Global {
  static AppPersistentData appPersistentData = AppPersistentData(themeMode: 0, languageCode: "zh", themeSelection: FlexScheme.sakura.name);

  static User self = User();

  static const defaultAvatarUrl = "assets/images/default_avatar.avif";

  static const baseUrl = "http://1.94.121.141";

  static const successCode = 0;

  static Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  static Future<bool?> accessTokenRefresh() async {
    if (self.isValidUser()) {
      Response response;
      response = await dio.get("/api/v1/tool/token/refresh");
      debugPrint("Global.startAsyncTask[Access-Token]: ${response.data}");
      if (response.statusCode != 200) {
        return null;
      }
      if (response.data["code"] == successCode) {
        self.accessToken = response.data["data"]["access_token"];
        debugPrint("Global.startAsyncTask[self:Access-Token]: ${self.accessToken}");
        Response r;
        r = await dio.get('/api/v1/user/info', data: {
          "user_id": self.id,
        });
        if (r.data["code"] == successCode) {
          var user = User.fromJson(r.data["data"]);
          user = user.copyWith(accessToken: self.accessToken, refreshToken: self.refreshToken);
          Global.self = user;
          Storage.storePersistentData(appPersistentData.copyWith(user: user));
          updateDioToken(accessToken: user.accessToken, refreshToken: user.refreshToken);
          return true;
        } else {
          return false;
        }
      }
      return false;
    }
    return false;
  }

  static Future<bool?> refreshTokenRefresh() async {
    if (self.isValidUser()) {
      Response response;
      response = await dio.get("/api/v1/tool/refresh_token/refresh");
      debugPrint("Global.startAsyncTask[Refresh-Token]: ${response.data}");
      if (response.statusCode != 200) {
        return null;
      }
      if (response.data["code"] == successCode) {
        self.refreshToken = response.data["data"]["refresh_token"];
        Storage.storePersistentData(appPersistentData.copyWith(user: self));
        updateDioToken(accessToken: self.accessToken, refreshToken: self.refreshToken);
        return true;
      }
      return false;
    }
    return false;
  }

  static List<Timer> tasks = [];

  static startAsyncTask() {
    for (final task in tasks) {
      task.cancel();
    }
    tasks.clear();

    tasks.add(Timer.periodic(const Duration(minutes: 45), (timer) async {
      debugPrint("Global.startAsyncTask.accessTokenRefresh");
      await accessTokenRefresh();
    }));

    tasks.add(Timer.periodic(const Duration(days: 1), (timer) async {
      debugPrint("Global.startAsyncTask.refreshTokenRefresh");
      await refreshTokenRefresh();
    }));
  }

  static updateDioToken({String? accessToken, String? refreshToken, bool clear = false}) {
    if (clear) {
      dio.options.headers.remove("Access-Token");
      dio.options.headers.remove("Refresh-Token");
      return;
    }
    if (accessToken != null) {
      dio.options.headers["Access-Token"] = accessToken;
    }
    if (refreshToken != null) {
      dio.options.headers["Refresh-Token"] = refreshToken;
    }
    debugPrint("Global.updateDioToken: ${dio.options.headers}");
  }

  static bool isLogin() {
    return self.isValidUser();
  }

  static Map<String, dynamic> cachedMap = {};
  static Map<String, User> cachedMapUser = {};
  static Map<String, Video> cachedMapVideo = {};
  static List<Video> cachedSearchVideoList = [];

  static Map<String, MapEntry<List<Video>, int>> cachedVideoList = {};
  static Map<String, MapEntry<List<User>, bool>> cachedMapUserList = {};
  static Map<String, MapEntry<List<Video>, bool>> cachedMapVideoList = {};
  static Map<String, MapEntry<List<Comment>, bool>> cachedMapCommentList = {};
  static Map<String, MapEntry<List<Activity>, bool>> cachedMapDynamicList = {};

  static resetAllCache() {
    cachedMap = {};
    cachedMapUser = {};
    cachedMapVideo = {};
    cachedSearchVideoList = [];
    cachedVideoList = {};
    cachedMapUserList = {};
    cachedMapVideoList = {};
    cachedMapCommentList = {};
    cachedMapDynamicList = {};
  }

  static const List<String> categoryList = ["游戏", "知识", "生活", "军事", "影音", "新闻"];
}

class Storage {
  static storePersistentData(AppPersistentData data) async {
    final prefs = await SharedPreferences.getInstance();
    data = data.user != null
        ? data
        : AppPersistentData(
            themeMode: data.themeMode, languageCode: data.languageCode, themeSelection: data.themeSelection, user: Global.self);
    await prefs.setString("appPersistentData", jsonEncode(data));
    debugPrint("Storage.storePersistentData: ${data.toJson()}, with user: ${data.user?.toJson()}");
  }

  static Future<AppPersistentData> getPersistentData() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("appPersistentData");
    if (data != null) {
      debugPrint("Storage.getPersistentData: $data");
      return AppPersistentData.fromJson(jsonDecode(data));
    } else {
      debugPrint("Storage.getPersistentData: default");
      return AppPersistentData(themeMode: 0, languageCode: "zh", themeSelection: FlexScheme.sakura.name, user: null);
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
