import 'package:flutter/material.dart';
import 'package:last_moment/components/appbar.dart';
import 'package:last_moment/components/searchbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class GetLength extends StatefulWidget {
  const GetLength({super.key});

  @override
  State<GetLength> createState() => _GetLengthState();
}

class _GetLengthState extends State<GetLength> {
  final TextEditingController _controller = TextEditingController();
  final String apiKey = 'Api Key'; // Replace with your API key
  String displayText = '';
  bool _loading = false;

  Future<void> fetchPlaylistLength(String playlistLink) async {
    setState(() {
      _loading = true;
      displayText = '';
    });

    final playlistId = getId(playlistLink);
    if (playlistId == 'invalid_playlist_link') {
      setState(() {
        displayText = 'Invalid playlist link';
        _loading = false;
      });
      return;
    }

    final url1 = 'https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=50&fields=items/contentDetails/videoId,nextPageToken&key=$apiKey&playlistId=$playlistId&pageToken=';
    final url2 = 'https://www.googleapis.com/youtube/v3/videos?&part=contentDetails&id={}&key=$apiKey&fields=items/contentDetails/duration';
    Duration totalDuration = Duration();
    int videoCount = 0;
    String nextPageToken = '';

    while (true) {
      final response1 = await http.get(Uri.parse(url1 + nextPageToken));
      final results1 = json.decode(response1.body);
      if (results1.containsKey('error')) {
        setState(() {
          displayText = results1['error']['message'];
          _loading = false;
        });
        return;
      }

      final videoIds = (results1['items'] as List)
          .map((item) => item['contentDetails']['videoId'])
          .toList();
      videoCount += videoIds.length;

      final response2 = await http.get(Uri.parse(url2.replaceFirst('{}', videoIds.join(','))));
      final results2 = json.decode(response2.body);
      if (results2.containsKey('error')) {
        setState(() {
          displayText = results2['error']['message'];
          _loading = false;
        });
        return;
      }

      for (var item in results2['items']) {
        final duration = parseDuration(item['contentDetails']['duration']);
        totalDuration += duration;
      }

      if (results1.containsKey('nextPageToken') && videoCount < 500) {
        nextPageToken = results1['nextPageToken'];
      } else {
        break;
      }
    }

    setState(() {
      displayText = 'No of videos : $videoCount\n'
          'Average length of video : ${formatDuration((totalDuration.inSeconds / videoCount).round())}\n'
          'Total length of playlist : ${formatDuration(totalDuration.inSeconds)}\n'
          'At 1.25x : ${formatDuration((totalDuration.inSeconds / 1.25).round())}\n'
          'At 1.50x : ${formatDuration((totalDuration.inSeconds / 1.5).round())}\n'
          'At 1.75x : ${formatDuration((totalDuration.inSeconds / 1.75).round())}\n'
          'At 2.00x : ${formatDuration((totalDuration.inSeconds / 2).round())}';
      _loading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      backgroundColor: Color.fromRGBO(37, 40, 44, 5),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Find the length of any YouTube playlist:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CusotomSearchBar(
                  controller: _controller,
                  hint: 'youtube.com/playlist?list=ID',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shadowColor: Colors.greenAccent),
                onPressed: () {
                  final playlistUrl = _controller.text;
                  if (playlistUrl.isNotEmpty) {
                    fetchPlaylistLength(_controller.text);
                  }
                },
                child: Text(
                  'Analyze',
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 20),
              _loading
                  ? Lottie.asset('assets/load2.json')
                  : Text(
                      displayText,
                      style: TextStyle(color: Colors.white),
                    ),
               SizedBox(height: 50,),    
              SizedBox(height: 10),
              Text(
                "Made With ❤️ by Saurabh Maurya",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
