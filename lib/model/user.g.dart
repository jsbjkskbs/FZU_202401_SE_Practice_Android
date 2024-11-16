// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      name: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      followerCount: (json['followerCount'] as num?)?.toInt(),
      followingCount: (json['followingCount'] as num?)?.toInt(),
      likeCount: (json['likeCount'] as num?)?.toInt(),
      createdAt: (json['created_at'] as num?)?.toInt(),
      updatedAt: (json['updated_at'] as num?)?.toInt(),
      deletedAt: (json['deleted_at'] as num?)?.toInt(),
      isFollowed: json['isFollowed'] as bool?,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.name,
      'email': instance.email,
      'password': instance.password,
      'avatar_url': instance.avatarUrl,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'likeCount': instance.likeCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'isFollowed': instance.isFollowed,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
