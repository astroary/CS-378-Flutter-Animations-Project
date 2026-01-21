/*
Aryansingh Chauhan, CS 378 Project 4 - Implicit/Explicit Animations
Prof - Ugo Buy

I have 3 implicit and 3 explicit animations. Each animation has it's own file.
I followed the slides to determine whether an animation is implicit or explicit.
The first 3 animations in my listview are explicit as they are going on forever, and the last 3 are implicit as they stop.
For each animation file I have, I have a header that explains how I determined whether it's implicit/explicit
 */


import 'package:flutter/material.dart';
import 'bouncing_ucl_ball.dart';
import 'rotating_logo.dart';
import 'text_360.dart';
import 'image_enlarging_shrinking.dart';
import 'text_changing_bk_gnd_color.dart';
import 'moving_icon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animation Simulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Aryan's Animation List"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? currAnim;
  String? animStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 15,
        shadowColor: Colors.grey[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: () {
              setState(() {
                currAnim = null;
                animStatus = null;
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              currAnim == null
                  ? 'No Animation Selected'
                  : animStatus != null
                  ? '$currAnim animation is $animStatus'
                  : '$currAnim animation status unknown',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: currAnim == null ? 3 : 1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8E44AD),
                    Color(0xFFFF5E3A),
                    Colors.lime,
                  ],
                  stops: [0.15, 0.83, 1.0],
                ),
              ),
              child: ListView(
                children: <Widget>[
                  animTile('Bouncing UCL Ball'),
                  animTile('Barca Logo'),
                  animTile('Text 360°'),
                  animTile('Image Enlarging/Shrinking'),
                  animTile('Multi-colour Background'),
                  animTile('Moving Ramen'),
                ],
              ),
            ),
          ),
          if (currAnim != null)
            Expanded(
              flex: 2,
              child: Center(
                child: getSelectAnim(),
              ),
            ),
        ],
      ),
    );
  }

  /// returns the appropriate animation based on my/user selection
  Widget getSelectAnim() {
    switch (currAnim) {
      case 'Bouncing UCL Ball':
        return const UclBallBouncing();
      case 'Barca Logo':
        return const RotatingLogo();
      case 'Text 360°':
        return const Text360();

    // now the next 3 are implicit so need to track when they are completed vs in-progress/playing
      case 'Image Enlarging/Shrinking':
        return ImageEnlargingShrinking(
          status: updateAnimStat,
        );
      case 'Multi-colour Background':
        return TextChangingBackgroundColor(
          status: updateAnimStat,
        );
      case 'Moving Ramen':
        return MovingIcon(
          status: updateAnimStat,
        );
      default:
        return Text(
          'Selected Animation: $currAnim',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        );
    }
  }

  /// method to update animation status
  void updateAnimStat(String stat) {
    setState(() {
      animStatus = stat;
    });
  }

  Widget animTile(String animName) {  // i initially did not have the card widget, just the list tile. but i saw that elevation could not be added to list tile directly so required a card
    final isSelected = currAnim == animName;
    return Card(
      elevation: isSelected ? 8.0 : 0.0,
      shadowColor: Colors.grey,
      color: isSelected ? Colors.amber : Colors.transparent,
      // shape: isSelected
      //     ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
      //     : null,
      child: ListTile(
        title: Text(
          animName,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() {
            currAnim = animName;
            // Determine the status based on the animation type. my explicits will always be playing
            if (animName == 'Bouncing UCL Ball' || animName == 'Barca Logo' || animName == 'Text 360°') animStatus = 'playing';
            else animStatus = null; // status for implicit animations handled by callbacks for each imp anim
          });
        },
      ),
    );
  }
}
