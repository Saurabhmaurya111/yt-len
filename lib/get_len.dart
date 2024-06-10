import 'package:flutter/material.dart';
import 'package:last_moment/backend/fetch_Playlist_Items.dart';
import 'package:last_moment/backend/fetch_total_duration.dart';
import 'package:last_moment/backend/fomat_duration.dart';
import 'package:last_moment/backend/parseplaylistid.dart';
import 'package:last_moment/components/appbar.dart';
import 'package:last_moment/components/searchbar.dart';

class GetLength extends StatefulWidget {
  const GetLength({super.key});

  @override
  State<GetLength> createState() => _GetLengthState();
}

class _GetLengthState extends State<GetLength> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String _totalDuration = '';

  Future<void> fetchPlaylistDuration(String playlistUrl) async {
    setState(() {
      _loading = true;
      _totalDuration = '';
    });
    print('Fetching playlist duration for URL: $playlistUrl');

    final playlistId = parsePlaylistId(playlistUrl);
    print('Parsed playlist ID: $playlistId');

    if (playlistId == null) {
      setState(() {
        _loading = false;
        _totalDuration = 'Invalid playlist URL';
      });
      return;
    }
    try {
      final videoIds = await fetchPlaylistItems(playlistId);
      print('Fetched video IDs: $videoIds');
      final totalDuration = await fetchTotalDuration(videoIds);
      print('Fetched total duration: $totalDuration');
      setState(() {
        _totalDuration = formatDuration(totalDuration);
        print('Formatted duration: $_totalDuration');
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        _totalDuration = 'Error fetching playlist duration: $error';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      backgroundColor: Color.fromRGBO(37, 40, 44, 5),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
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
                  fetchPlaylistDuration(playlistUrl);
                }
              },
              child: Text(
                'Analyze',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ),
            
            if (_loading)
              CircularProgressIndicator(
                color: Colors.white,
              )
            else
              Text(
                _totalDuration,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Disclaimer",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            Text(
              "You can enter a playlist link, playlist ID or even a video link from the playlist! ",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            Spacer(),
            Text(
              "Made With ❤️ by Saurabh Maurya",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
