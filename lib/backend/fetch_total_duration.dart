
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:last_moment/backend/chunk_list.dart';
  Future<int> fetchTotalDuration(List<String> videoIds) async {
    final apiKey = 'AIzaSyA74j1zbmZ9xVNaGdRlJNQiOtyDIe1VXKI';
    //AIzaSyA74j1zbmZ9xVNaGdRlJNQiOtyDIe1VXKI
    //AIzaSyA74j1zbmZ9xVNaGdRlJNQiOtyDIe1VXKI
    final videoIdChunks = chunkList(videoIds, 50); // API allows up to 50 video IDs per request
    int totalDuration = 0;

    for (final chunk in videoIdChunks) {
      final videoIdsStr = chunk.join(',');
      final url = 'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=$videoIdsStr&key=$apiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load video durations');
      }
      final data = json.decode(response.body);
      for (final item in data['items']) {
        final durationStr = item['contentDetails']['duration'];
        totalDuration += parseDuration(durationStr);
      }
    }

    return totalDuration;
  }




    int parseDuration(String duration) {
    final regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');
    final match = regex.firstMatch(duration)!;

    final hours = int.parse(match.group(1)?.replaceAll('H', '') ?? '0');
    final minutes = int.parse(match.group(2)?.replaceAll('M', '') ?? '0');
    final seconds = int.parse(match.group(3)?.replaceAll('S', '') ?? '0');

    return hours * 3600 + minutes * 60 + seconds;
  }