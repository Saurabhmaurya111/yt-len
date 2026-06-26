class PlaylistLengthResult {
  const PlaylistLengthResult({
    required this.videoCount,
    required this.totalDurationSeconds,
  });

  final int videoCount;
  final int totalDurationSeconds;

  int get averageDurationSeconds =>
      videoCount > 0 ? (totalDurationSeconds / videoCount).round() : 0;

  int durationAtSpeed(double speed) =>
      (totalDurationSeconds / speed).round();
}
