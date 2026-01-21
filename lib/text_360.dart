/*

I determined this animation to be an explicit animation based on the following from the slides:

1. Animation must repeat indefinitely:
      -> True
         The text continuously rotates 360° horizontally without stopping, requiring the animation
         to loop indefinitely.

2. Animation is discontinuous (parts of animated widgets change position/size discontinuously):
      -> False
         The rotation of the text is smooth and continuous, maintaining consistent size and position
         throughout the animation.

3. Animation involves coordination among multiple objects:
      -> False
         The animation involves only a single text widget rotating horizontally, with no coordination
         required among multiple widgets or objects.

Since at least one condition for explicit animations is True, I implemented this as an explicit animation

 */

import 'package:flutter/material.dart';
import 'dart:math';

class Text360 extends StatefulWidget {
  const Text360({super.key});

  @override
  _Text360State createState() => _Text360State();
}

class _Text360State extends State<Text360> with SingleTickerProviderStateMixin {
  late AnimationController text360AnimController;
  late Animation<double> textAnim;
  bool isPlaying = true;
  bool isReversed = false;

  @override
  void initState() {
    super.initState();

    text360AnimController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    textAnim = Tween<double>(begin: 0, end: 2 * pi).animate(text360AnimController);

    // Add a status listener to manage looping manually based on direction
    text360AnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!isReversed) {
          text360AnimController.forward(from: 0.0);
        }
      } else if (status == AnimationStatus.dismissed) {
        if (isReversed) {
          text360AnimController.reverse(from: 1.0);
        }
      }
    });
    text360AnimController.forward();  // by default, I want the anim to rotate clock-wise
  }

  @override
  /// Prof said we should use dispose even tho dart is a garbage collected language
  void dispose() {
    text360AnimController.dispose();
    super.dispose();
  }

  /// Toggle between pausing and resuming the animation
  void pauseResumeFunc() {
    setState(() {
      if (isPlaying) {
        text360AnimController.stop();
      } else {
        if (isReversed) {
          text360AnimController.reverse(from: text360AnimController.value);
        } else {
          text360AnimController.forward(from: text360AnimController.value);
        }
      }
      isPlaying = !isPlaying;
    });
  }

  /// Reverse the direction of the animation. If the animation is paused, then I configured
  /// my code to wait for reverse to work until the reume button is pressed, just like a traditional
  /// pause/resume button functionality
  void reverse() {
    setState(() {
      isReversed = !isReversed;
      if (isPlaying) {
        text360AnimController.stop();
        if (isReversed) {
          text360AnimController.reverse(from: text360AnimController.value);
        } else {
          text360AnimController.forward(from: text360AnimController.value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: AnimatedBuilder(
            animation: textAnim,
            builder: (context, child) {
              return Transform.rotate(
                angle: textAnim.value,
                child: const Text(
                  "post-tequila",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: pauseResumeFunc,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              tooltip: isPlaying ? 'Pause' : 'Resume',
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: reverse,
              icon: const Icon(Icons.settings_backup_restore),
              tooltip: 'Reverse',
            ),
          ],
        ),
      ],
    );
  }
}

