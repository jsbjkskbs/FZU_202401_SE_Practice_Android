import 'package:fulifuli_app/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'user')
  User? user;
  @JsonKey(name: 'otype')
  String? oType;
  @JsonKey(name: 'oid')
  String? oId;
  @JsonKey(name: 'root_id')
  String? rootId;
  @JsonKey(name: 'parent_id')
  String? parentId;
  @JsonKey(name: 'like_count')
  int? likeCount;
  @JsonKey(name: 'child_count')
  int? childCount;
  @JsonKey(name: 'content')
  String? content;
  @JsonKey(name: 'created_at')
  int? createdAt;
  @JsonKey(name: 'updated_at')
  int? updatedAt;
  @JsonKey(name: 'deleted_at')
  int? deletedAt;
  @JsonKey(name: 'is_liked')
  bool? isLiked;

  Comment({
    this.id,
    this.user,
    this.oType,
    this.oId,
    this.rootId,
    this.parentId,
    this.likeCount,
    this.childCount,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isLiked,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  Comment copyWith({
    String? id,
    User? user,
    String? oType,
    String? oId,
    String? rootId,
    String? parentId,
    int? likeCount,
    int? childCount,
    String? content,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    bool? isLiked,
  }) {
    return Comment(
      id: id ?? this.id,
      user: user ?? this.user,
      oType: oType ?? this.oType,
      oId: oId ?? this.oId,
      rootId: rootId ?? this.rootId,
      parentId: parentId ?? this.parentId,
      likeCount: likeCount ?? this.likeCount,
      childCount: childCount ?? this.childCount,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
