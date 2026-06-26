class PlaylistUtils {
  PlaylistUtils._();

  static String extractPlaylistId(String playlistLink) {
    final regex = RegExp(r'^([\S]+list=)?([\w_-]+)[\S]*$');
    final match = regex.firstMatch(playlistLink);
    return match != null ? match.group(2)! : 'invalid_playlist_link';
  }

  static bool isValidPlaylistId(String playlistId) {
    return playlistId != 'invalid_playlist_link';
  }
}
