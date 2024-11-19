// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String?,
      oType: json['otype'] as String?,
      oId: json['oid'] as String?,
      rootId: json['root_id'] as String?,
      parentId: json['parent_id'] as String?,
      likeCount: (json['like_count'] as num?)?.toInt(),
      childCount: (json['child_count'] as num?)?.toInt(),
      content: json['content'] as String?,
      createdAt: (json['created_at'] as num?)?.toInt(),
      updatedAt: (json['updated_at'] as num?)?.toInt(),
      deletedAt: (json['deleted_at'] as num?)?.toInt(),
      isLiked: json['is_liked'] as bool?,
    )..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'otype': instance.oType,
      'oid': instance.oId,
      'root_id': instance.rootId,
      'parent_id': instance.parentId,
      'like_count': instance.likeCount,
      'child_count': instance.childCount,
      'content': instance.content,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'is_liked': instance.isLiked,
    };
