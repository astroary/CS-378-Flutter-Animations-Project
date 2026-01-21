/*

I determined this animation to be an explicit animation based on the following from the slides:

1. Animation must repeat indefinitely:
      -> True
         The logo is designed to rotate continuously without stopping, requiring the animation to loop
         indefinitely.

2. Animation is discontinuous (parts of animated widgets change position/size discontinuously):
      -> False
         The rotation of the logo is smooth and continuous, with no abrupt changes in position or size.

3. Animation involves coordination among multiple objects:
      -> False
         The animation involves only a single logo widget rotating within its container,
         with no coordination required among multiple widgets or objects.

Since at least one condition for explicit animations is True, I implemented this as an explicit animation

 */

import 'package:flutter/material.dart';
import 'dart:math';

class RotatingLogo extends StatefulWidget {
  const RotatingLogo({super.key});

  @override
  BarcaLogoRotate createState() => BarcaLogoRotate();
}

class BarcaLogoRotate extends State<RotatingLogo> with SingleTickerProviderStateMixin {
  late AnimationController logoController;
  late Animation<double> rotateAnim;
  bool isPlaying = true;
  bool isReversed = false;

  @override
  void initState() {
    super.initState();
    logoController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    rotateAnim = Tween<double>(begin: 0, end: 2 * pi).animate(logoController);

    // added a status listener to manage continuous looping based on direction
    logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!isReversed) {
          logoController.forward(from: 0.0);
        }
      } else if (status == AnimationStatus.dismissed) {
        if (isReversed) {
          logoController.reverse(from: 1.0);
        }
      }
    });
    logoController.forward();  // dby default, i have set the logo to rotate in clock-wise dir
  }

  @override
  /// Prof said we should use dispose even tho dart is a garbage collected language
  void dispose() {
    logoController.dispose();
    super.dispose();
  }

  /// Toggle between pausing and resuming the animation
  void pauseResumeFunc() {
    setState(() {
      if (isPlaying) {
        logoController.stop();
      } else {  // resume the animation in the current direction
        if (isReversed) {
          logoController.reverse(from: logoController.value);
        } else {
          logoController.forward(from: logoController.value);
        }
      }
      isPlaying = !isPlaying;
    });
  }

  /// Reverse the direction of the animation. If the animation is paused, then I configured
  /// my code to wait for reverse to work until the resume button is pressed, just like a traditional
  /// pause/resume button functionality
  void reverse() {
    setState(() {
      isReversed = !isReversed;
      if (isPlaying) {
        logoController.stop();
        if (isReversed) {
          logoController.reverse(from: logoController.value);
        } else {
          logoController.forward(from: logoController.value);
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
            animation: rotateAnim,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotateAnim.value),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.network(
                    "https://neon-factory.com/cdn/shop/products/barca-gold-and-black-rgb-neon-sign-46965-blue_1024x1024@2x.jpg?v=1699343606",
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

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