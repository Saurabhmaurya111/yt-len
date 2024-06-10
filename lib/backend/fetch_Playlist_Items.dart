import 'package:http/http.dart' as http;
import 'dart:convert';

  Future<List<String>> fetchPlaylistItems(String playlistId) async {
    final apiKey = 'AIzaSyA74j1zbmZ9xVNaGdRlJNQiOtyDIe1VXKI';
    final url = 'https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=50&playlistId=$playlistId&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load playlist items');
    }
    final data = json.decode(response.body);
    final videoIds = (data['items'] as List).map((item) => item['contentDetails']['videoId'] as String).toList();
    return videoIds;
  }