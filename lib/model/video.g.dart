// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      id: json['id'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      videoUrl: json['video_url'] as String?,
      coverUrl: json['cover_url'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      visitCount: (json['visit_count'] as num?)?.toInt(),
      likeCount: (json['like_count'] as num?)?.toInt(),
      commentCount: (json['comment_count'] as num?)?.toInt(),
      category: json['category'] as String?,
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: (json['created_at'] as num?)?.toInt(),
      updatedAt: (json['updated_at'] as num?)?.toInt(),
      deletedAt: (json['deleted_at'] as num?)?.toInt(),
      status: json['status'] as String?,
      isLiked: json['is_liked'] as bool?,
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'video_url': instance.videoUrl,
      'cover_url': instance.coverUrl,
      'title': instance.title,
      'description': instance.description,
      'visit_count': instance.visitCount,
      'like_count': instance.likeCount,
      'comment_count': instance.commentCount,
      'category': instance.category,
      'labels': instance.labels,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'status': instance.status,
      'is_liked': instance.isLiked,
    };
