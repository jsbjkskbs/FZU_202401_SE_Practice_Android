// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String?,
      refVideo: json['ref_video'] as String?,
      refActivity: json['ref_activity'] as String?,
      likeCount: (json['like_count'] as num?)?.toInt(),
      commentCount: (json['comment_count'] as num?)?.toInt(),
      createdAt: (json['created_at'] as num?)?.toInt(),
      updatedAt: (json['updated_at'] as num?)?.toInt(),
      deletedAt: (json['deleted_at'] as num?)?.toInt(),
      isLiked: json['is_liked'] as bool?,
    )..images =
        (json['image'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'content': instance.content,
      'image': instance.images,
      'ref_video': instance.refVideo,
      'ref_activity': instance.refActivity,
      'like_count': instance.likeCount,
      'comment_count': instance.commentCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'is_liked': instance.isLiked,
    };
