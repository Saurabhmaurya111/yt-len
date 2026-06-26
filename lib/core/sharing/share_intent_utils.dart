import 'package:last_moment/core/utils/playlist_utils.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntentUtils {
  ShareIntentUtils._();

  static final _playlistUrlRegex = RegExp(
    r'https?://(?:www\.|m\.)?youtube\.com/(?:playlist\?[^\s]+|watch\?[^\s]*list=[^\s&]+)',
    caseSensitive: false,
  );

  /// Extracts a YouTube playlist URL from shared text, if present.
  static String? extractPlaylistUrl(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri != null && _hasPlaylistListParam(uri)) {
      return trimmed;
    }

    final match = _playlistUrlRegex.firstMatch(trimmed);
    if (match != null) {
      return match.group(0);
    }

    if (PlaylistUtils.isValidPlaylistId(PlaylistUtils.extractPlaylistId(trimmed))) {
      return trimmed;
    }

    return null;
  }

  static String? extractFromSharedMedia(List<SharedMediaFile> files) {
    for (final file in files) {
      if (file.type == SharedMediaType.text || file.type == SharedMediaType.url) {
        final url = extractPlaylistUrl(file.path);
        if (url != null) return url;
      }
    }
    return null;
  }

  static bool _hasPlaylistListParam(Uri uri) {
    final listId = uri.queryParameters['list'];
    if (listId == null || listId.isEmpty) return false;

    final host = uri.host.toLowerCase();
    return host.contains('youtube.com') || host.contains('youtu.be');
  }
}
