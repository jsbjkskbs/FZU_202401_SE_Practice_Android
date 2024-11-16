import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'username')
  String? name;
  String? email;
  String? password;
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;
  int? followerCount;
  int? followingCount;
  int? likeCount;
  @JsonKey(name: 'created_at')
  int? createdAt;
  @JsonKey(name: 'updated_at')
  int? updatedAt;
  @JsonKey(name: 'deleted_at')
  int? deletedAt;
  bool? isFollowed;
  @JsonKey(name: 'access_token')
  String? accessToken;
  @JsonKey(name: 'refresh_token')
  String? refreshToken;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.avatarUrl,
    this.followerCount,
    this.followingCount,
    this.likeCount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isFollowed,
    this.accessToken,
    this.refreshToken,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? avatarUrl,
    int? followerCount,
    int? followingCount,
    int? likeCount,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
    bool? isFollowed,
    String? accessToken,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isFollowed: isFollowed ?? this.isFollowed,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  bool isValidUser() {
    return id != null && id!.isNotEmpty;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
