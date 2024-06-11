

  String getId(String playlistLink) {
    final regex = RegExp(r'^([\S]+list=)?([\w_-]+)[\S]*$');
    final match = regex.firstMatch(playlistLink);
    return match != null ? match.group(2)! : 'invalid_playlist_link';
  }

  Duration parseDuration(String isoString) {
    final regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');
    final match = regex.firstMatch(isoString);

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (match != null) {
      if (match.group(1) != null) {
        hours = int.parse(match.group(1)!.replaceAll('H', ''));
      }
      if (match.group(2) != null) {
        minutes = int.parse(match.group(2)!.replaceAll('M', ''));
      }
      if (match.group(3) != null) {
        seconds = int.parse(match.group(3)!.replaceAll('S', ''));
      }
    }

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final dayStr = days > 0 ? '$days day${days > 1 ? 's' : ''}, ' : '';
    final hourStr = hours > 0 ? '$hours hour${hours > 1 ? 's' : ''}, ' : '';
    final minuteStr = minutes > 0 ? '$minutes minute${minutes > 1 ? 's' : ''}, ' : '';
    final secondStr = '$seconds second${seconds != 1 ? 's' : ''}';

    return '$dayStr$hourStr$minuteStr$secondStr'.replaceFirst(RegExp(r', $'), '');
  }