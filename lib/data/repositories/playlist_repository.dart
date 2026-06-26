import 'package:last_moment/data/models/api_result.dart';
import 'package:last_moment/data/models/playlist_length_result.dart';
import 'package:last_moment/data/models/playlist_stats.dart';
import 'package:last_moment/data/services/backend_api_service.dart';

class PlaylistRepository {
  PlaylistRepository({BackendApiService? apiService})
      : _apiService = apiService ?? BackendApiService();

  final BackendApiService _apiService;

  Future<ApiResult<PlaylistLengthResult>> getPlaylistLength(
    String playlistLink,
  ) {
    return _apiService.fetchPlaylistLength(playlistLink);
  }

  Future<ApiResult<PlaylistStats>> getPlaylistStats(String playlistLink) {
    return _apiService.fetchPlaylistStats(playlistLink);
  }
}
