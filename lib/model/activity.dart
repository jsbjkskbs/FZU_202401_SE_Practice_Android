import 'package:fulifuli_app/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'user')
  User? user;
  @JsonKey(name: 'content')
  String? content;
  @JsonKey(name: 'image')
  List<String>? images;
  @JsonKey(name: 'ref_video')
  String? refVideo;
  @JsonKey(name: 'ref_activity')
  String? refActivity;
  @JsonKey(name: 'like_count')
  int? likeCount;
  @JsonKey(name: 'comment_count')
  int? commentCount;
  @JsonKey(name: 'created_at')
  int? createdAt;
  @JsonKey(name: 'updated_at')
  int? updatedAt;
  @JsonKey(name: 'deleted_at')
  int? deletedAt;
  @JsonKey(name: 'is_liked')
  bool? isLiked;

  Activity({
    this.id,
    this.user,
    this.content,
    this.refVideo,
    this.refActivity,
    this.likeCount,
    this.commentCount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isLiked,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  Activity copyWith({
    String? id,
    User? user,
    String? content,
    String? refVideo,
    String? refActivity,
    int? likeCount,
    int? commentCount,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    bool? isLiked,
  }) {
    return Activity(
      id: id ?? this.id,
      user: user ?? this.user,
      content: content ?? this.content,
      refVideo: refVideo ?? this.refVideo,
      refActivity: refActivity ?? this.refActivity,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
