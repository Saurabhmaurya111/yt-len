import 'package:flutter/material.dart';
import 'package:last_moment/compare2.dart';
// import 'package:last_moment/compare_page.dart';
import 'package:last_moment/get_len.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Last Moment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(37, 40, 44, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 100,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GetLength()));
                  },
                  child: Text('Get Length'),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
              child: Container(
                height: 100,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GetStats()));
                  },
                  child: Text('Compare Playlist'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
