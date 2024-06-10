import 'package:flutter/material.dart';
import 'package:last_moment/components/appbar.dart';
import 'package:last_moment/components/searchbar.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _GetLengthState();
}

class _GetLengthState extends State<ComparePage> {
  final TextEditingController _controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      
      backgroundColor: Color.fromRGBO(37, 40, 44, 5),
      body: Expanded(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Spacer(),
              Text(
                'Compare the length of any YouTube playlist:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Playlist 1:" , style: TextStyle(color: Colors.white ,fontSize: 20,
                    fontWeight: FontWeight.bold),),
                SizedBox(height: 8,),
              Center(
                child: CusotomSearchBar(hint: 'youtube.com/playlist?list=ID=1',controller: _controller2,),
              ),
                SizedBox(height: 8,),
                 Text("Playlist 2:" , style: TextStyle(color: Colors.white ,fontSize: 20,
                    fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Center(
                child: CusotomSearchBar(hint: 'youtube.com/playlist?list=ID=2',controller: _controller2,)
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  // color: Colors.white,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shadowColor: Colors.greenAccent),
                    onPressed: () {},
                    child: Text(
                      'Compare',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Disclaimer :",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                "You can enter a playlist link, playlist ID or even a video link from the playlist! ",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              Spacer(),
              Center(child: Text("Made With ❤️ by Saurabh Maurya" , style: TextStyle(color: Colors.white),))
            ],
          ),
        ),
      ),
    );
  }
}


