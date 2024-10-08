import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_moment/compare2.dart';
import 'package:last_moment/components/featured_box.dart';
import 'package:last_moment/components/pallet.dart';
import 'package:last_moment/get_len.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.mainFontColor,
        title: const Text(
          "Last Moment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: IconButton(
              onPressed: () {
                signUserOut();
              },
              icon: Icon(Icons.login_rounded, color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: EdgeInsets.symmetric(horizontal: 35).copyWith(
                top: 25,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Greetings, User what task can I do for you?',
                  style: TextStyle(
                    color: Pallete.mainFontColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10, left: 22),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Here are a few feature',
                style: TextStyle(
                  fontSize: 20,
                  color: Pallete.mainFontColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetLength(),
                      ),
                    );
                  },
                  child: FeatureBox(
                    color: Pallete.firstSuggestionBoxColor,
                    headerText: 'PlayList Calculator',
                    description:
                        'A smarter way to calculate length of playlist',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetStats(),
                      ),
                    );
                  },
                  child: FeatureBox(
                    color: Pallete.secondSuggestionBoxColor,
                    headerText: 'Compare Playlist',
                    description:
                        'Get inspired and stay creative with your personal assistant poowered by Youtube',
                  ),
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  headerText: 'Get Plan',
                  description:
                      'Under Construction will be ready soon. Which will be powered by many features.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
