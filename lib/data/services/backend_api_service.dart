import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:last_moment/core/config/api_config.dart';
import 'package:last_moment/data/models/api_result.dart';
import 'package:last_moment/data/models/playlist_length_result.dart';
import 'package:last_moment/data/models/playlist_stats.dart';

class BackendApiService {
  BackendApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String get _baseUrl => ApiConfig.backendBaseUrl;

  Future<ApiResult<PlaylistLengthResult>> fetchPlaylistLength(
    String playlistLink,
  ) async {
    return _post(
      '/api/playlist/length',
      {'url': playlistLink},
      (data) => PlaylistLengthResult(
        videoCount: data['videoCount'] as int,
        totalDurationSeconds: data['totalDurationSeconds'] as int,
      ),
    );
  }

  Future<ApiResult<PlaylistStats>> fetchPlaylistStats(
    String playlistLink,
  ) async {
    return _post(
      '/api/playlist/stats',
      {'url': playlistLink},
      (data) => PlaylistStats(
        videoCount: data['videoCount'] as int,
        totalViews: data['totalViews'] as int,
        totalLikes: data['totalLikes'] as int,
      ),
    );
  }

  Future<ApiResult<T>> _post<T>(
    String path,
    Map<String, String> body,
    T Function(Map<String, dynamic> data) fromJson,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          decoded['success'] == true) {
        return ApiSuccess(fromJson(decoded['data'] as Map<String, dynamic>));
      }

      final error = decoded['error'] as String? ?? 'Request failed';
      return ApiFailure(error);
    } on http.ClientException {
      return ApiFailure(
        'Cannot reach backend server. Make sure it is running on $_baseUrl',
      );
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }
}
