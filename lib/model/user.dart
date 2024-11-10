class User {
  late String id;
  late String name;
  late String email;
  late String password;
  late String avatarUrl;
  late int followerCount;
  late int followingCount;
  late int likeCount;

  User({
    this.id = "",
    this.name = "",
    this.email = "",
    this.password = "",
    this.avatarUrl = "",
    this.followerCount = 0,
    this.followingCount = 0,
    this.likeCount = 0,
  });

  bool isValidUser() {
    return id.isNotEmpty;
  }
}
