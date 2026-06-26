class PlaylistStats {
  const PlaylistStats({
    required this.videoCount,
    required this.totalViews,
    required this.totalLikes,
  });

  final int videoCount;
  final int totalViews;
  final int totalLikes;

  double get likePercentage =>
      totalViews > 0 ? (totalLikes / totalViews) * 100 : 0.0;
}
