// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppPersistentData _$AppPersistentDataFromJson(Map<String, dynamic> json) => AppPersistentData(
      themeMode: (json['themeMode'] as num).toInt(),
      languageCode: json['languageCode'] as String,
      themeSelection: json['themeSelection'] as String,
    );

Map<String, dynamic> _$AppPersistentDataToJson(AppPersistentData instance) => <String, dynamic>{
      'themeMode': instance.themeMode,
      'themeSelection': instance.themeSelection,
      'languageCode': instance.languageCode,
    };
