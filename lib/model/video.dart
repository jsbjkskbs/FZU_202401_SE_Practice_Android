class Video {
  late final String id;
  late final String userId;
  late final String title;
  late final String description;
  late final String category;
  late final List<String> labels;
  late final String coverUrl;
  late final String videoUrl;
  late final int viewCount;
  late final int likeCount;
  late final int commentCount;
  late final int createdAt;
  late final int updatedAt;
  late final int deletedAt;
  late final String status;

  Video({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.labels,
    required this.coverUrl,
    required this.videoUrl,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.status,
  });

  Video clone() {
    return Video(
      id: id,
      userId: userId,
      title: title,
      description: description,
      category: category,
      labels: List<String>.from(labels),
      coverUrl: coverUrl,
      videoUrl: videoUrl,
      viewCount: viewCount,
      likeCount: likeCount,
      commentCount: commentCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      status: status,
    );
  }
}
