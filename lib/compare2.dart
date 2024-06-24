import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:last_moment/backend/api.dart';
import 'package:last_moment/backend/secret.dart';
import 'package:last_moment/components/appbar.dart';
import 'package:last_moment/components/searchbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/link.dart';

import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GetStats extends StatefulWidget {
  const GetStats({super.key});

  @override
  State<GetStats> createState() => _GetStatsState();
}

class _GetStatsState extends State<GetStats> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  String displayText = '';
  String result = '';
  Widget? linked;
  bool _loading = false;
  bool showbutton = true;
  double playlist1LikePercentage = 0.0;
  double playlist2LikePercentage = 0.0;

  Future<Map<String, dynamic>> fetchPlaylistStats(String playlistLink) async {
    final playlistId = getId(playlistLink);
    if (playlistId == 'invalid_playlist_link') {
      return {
        'error': 'Invalid playlist link',
      };
    }

    final url1 =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=contentDetails&maxResults=50&fields=items/contentDetails/videoId,nextPageToken&key=$apiKey&playlistId=$playlistId&pageToken=';
    final url2 =
        'https://www.googleapis.com/youtube/v3/videos?part=statistics&id={}&key=$apiKey&fields=items/statistics(viewCount,likeCount)';

    String nextPageToken = '';
    List<String> allVideoIds = [];
    int totalViews = 0;
    int totalLikes = 0;
    int videoCount = 0;

    // Fetch all video IDs from the playlist
    while (true) {
      final response1 = await http.get(Uri.parse(url1 + nextPageToken));
      final results1 = json.decode(response1.body);
      if (results1.containsKey('error')) {
        return {
          'error': results1['error']['message'],
        };
      }

      // Correct the type of videoIds list to List<String>
      final List<String> videoIds = (results1['items'] as List)
          .map((item) => item['contentDetails']['videoId'] as String)
          .toList();
      allVideoIds.addAll(videoIds);
      videoCount += videoIds.length;

      if (results1.containsKey('nextPageToken')) {
        nextPageToken = results1['nextPageToken'];
      } else {
        break;
      }
    }

    // Fetch statistics for all video IDs in chunks of 50
    for (var i = 0; i < allVideoIds.length; i += 50) {
      final chunkIds = allVideoIds.sublist(
          i, i + 50 > allVideoIds.length ? allVideoIds.length : i + 50);
      final response2 = await http
          .get(Uri.parse(url2.replaceFirst('{}', chunkIds.join(','))));
      final results2 = json.decode(response2.body);
      if (results2.containsKey('error')) {
        return {
          'error': results2['error']['message'],
        };
      }

      for (var item in results2['items']) {
        totalViews += int.parse(item['statistics']['viewCount']);
        if (item['statistics'].containsKey('likeCount')) {
          totalLikes += int.parse(item['statistics']['likeCount']);
        }
      }
    }

    return {
      'videoCount': videoCount,
      'totalViews': totalViews,
      'totalLikes': totalLikes,
    };
  }

  Future<void> comparePlaylists() async {
    setState(() {
      _loading = true;
      displayText = '';
    });

    final playlistUrl1 = _controller1.text;
    final playlistUrl2 = _controller2.text;

    final results1 = await fetchPlaylistStats(playlistUrl1);
    final results2 = await fetchPlaylistStats(playlistUrl2);

    if (results1.containsKey('error')) {
      setState(() {
        displayText = 'Error in Playlist 1: ${results1['error']}';
        _loading = false;
      });
      return;
    }

    if (results2.containsKey('error')) {
      setState(() {
        displayText = 'Error in Playlist 2: ${results2['error']}';
        _loading = false;
      });
      return;
    }

    double percentage1 = results1['totalViews'] > 0
        ? (results1['totalLikes'] / results1['totalViews']) * 100
        : 0.0;
    double percentage2 = results2['totalViews'] > 0
        ? (results2['totalLikes'] / results2['totalViews']) * 100
        : 0.0;

    setState(() {
      displayText = 'Playlist 1:\n'
          'Total Videos: ${results1['videoCount']}\n'
          'Total Views: ${results1['totalViews']}\n'
          'Total Likes: ${results1['totalLikes']}\n'
          'Likes Percentage: ${percentage1.toStringAsFixed(2)}%\n\n'
          'Playlist 2:\n'
          'Total Videos: ${results2['videoCount']}\n'
          'Total Views: ${results2['totalViews']}\n'
          'Total Likes: ${results2['totalLikes']}\n'
          'Likes Percentage: ${percentage2.toStringAsFixed(2)}%';
      playlist1LikePercentage = percentage1;
      playlist2LikePercentage = percentage2;
      _loading = false;
      showbutton = false;
    });
  }

  void compareNumbers() {
    double firstNumber =
        double.tryParse(playlist1LikePercentage.toStringAsFixed(2)) ?? 0;
    double secondNumber =
        double.tryParse(playlist2LikePercentage.toStringAsFixed(2)) ?? 0;

    if (firstNumber > secondNumber) {
      setState(() {
        result = 'Playlist 1 is best ';
        linked = Link(
            uri: Uri.parse(_controller1.text),
            builder: (context, followLink) =>
                TextButton(onPressed: followLink, child: Text('Click here')));
      });
    } else if (firstNumber < secondNumber) {
      setState(() {
        result = 'Playlist 2 is best ';
        linked = Link(
          uri: Uri.parse(_controller2.text),
          builder: (context, followLink) => TextButton(
            onPressed: followLink,
            child: Text(
              'Click here',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        );
      });
    } else {
      setState(() {
        result = 'Both numbers are equal. Choose any one';
      });
    }
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
                'Compare YouTube Playlists:',
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
                  controller: _controller1,
                  hint: 'youtube.com/playlist?list=ID (Playlist 1)',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CusotomSearchBar(
                  controller: _controller2,
                  hint: 'youtube.com/playlist?list=ID (Playlist 2)',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shadowColor: Colors.greenAccent),
                onPressed: () async {
                  await comparePlaylists();
                  compareNumbers();
                },
                child: Text(
                  'Compare',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 10),
              _loading
                  ? Lottie.asset('assets/load3.json')
                  : Column(
                      children: [
                        Text(
                          displayText,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10),
                     showbutton? SizedBox(
                      height: 0,
                     ) : ElevatedButton(
                          child: Text('View Stats' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w400),),
                          style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.black,
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Playlist 1 Likes Percentage',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        CircularPercentIndicator(
                                          radius: 100.0,
                                          animation: true,
                                          animationDuration: 1500,
                                          lineWidth: 15.0,
                                          percent: 0.4,
                                          center: new Text(
                                            '${playlist1LikePercentage.toStringAsFixed(2)}%',
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                                color: Colors.white),
                                          ),
                                          circularStrokeCap:
                                              CircularStrokeCap.butt,
                                          backgroundColor: Colors.white,
                                          progressColor: Colors.red,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Playlist 2 Likes Percentage',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        CircularPercentIndicator(
                                          radius: 100.0,
                                          animation: true,
                                          animationDuration: 1500,
                                          lineWidth: 15.0,
                                          percent: 0.4,
                                          center: new Text(
                                            '${playlist2LikePercentage.toStringAsFixed(2)}%',
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                                color: Colors.white),
                                          ),
                                          circularStrokeCap:
                                              CircularStrokeCap.butt,
                                          backgroundColor: Colors.white,
                                          progressColor: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )
                      ],
                    ),
              SizedBox(height: 50),
              Text(
                result,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              linked ?? SizedBox(),
              SizedBox(
                height: 40,
              ),
              Text(
                "Made With ❤️ by Saurabh Maurya",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
