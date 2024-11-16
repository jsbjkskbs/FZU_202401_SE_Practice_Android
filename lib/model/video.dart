import 'package:fulifuli_app/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

@JsonSerializable()
class Video {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'user')
  User? user;
  @JsonKey(name: 'video_url')
  String? videoUrl;
  @JsonKey(name: 'cover_url')
  String? coverUrl;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'visit_count')
  int? visitCount;
  @JsonKey(name: 'like_count')
  int? likeCount;
  @JsonKey(name: 'comment_count')
  int? commentCount;
  @JsonKey(name: 'category')
  String? category;
  @JsonKey(name: 'labels')
  List<String>? labels;
  @JsonKey(name: 'created_at')
  int? createdAt;
  @JsonKey(name: 'updated_at')
  int? updatedAt;
  @JsonKey(name: 'deleted_at')
  int? deletedAt;
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'is_liked')
  bool? isLiked;

  Video(
      {this.id,
      this.user,
      this.videoUrl,
      this.coverUrl,
      this.title,
      this.description,
      this.visitCount,
      this.likeCount,
      this.commentCount,
      this.category,
      this.labels,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.status,
      this.isLiked});

  Video copyWith({
    String? id,
    User? user,
    String? videoUrl,
    String? coverUrl,
    String? title,
    String? description,
    int? visitCount,
    int? likeCount,
    int? commentCount,
    String? category,
    List<String>? labels,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    String? status,
    bool? isLiked,
  }) {
    return Video(
      id: id ?? this.id,
      user: user ?? this.user,
      videoUrl: videoUrl ?? this.videoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      visitCount: visitCount ?? this.visitCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      category: category ?? this.category,
      labels: labels ?? this.labels,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      status: status ?? this.status,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}
