/*
I determined this animation to be an explicit animation based on the following from the slides:

1. Animation must repeat indefinitely:
      -> True
         The soccer ball continuously bounces up and down without stopping, requiring the animation
         to loop indefinitely.

2. Animation is discontinuous (parts of animated widgets change position/size discontinuously):
      -> False
         The ball's movement is smooth and continuous as it bounces, with gradual changes in position and
         size to simulate realistic motion.

3. Animation involves coordination among multiple objects:
      -> False
         The animation involves only the soccer ball moving within its container, with no coordination
         required among multiple widgets or objects.

Since at least one condition for explicit animations is True, I implemented this as an explicit animation
*/

import 'package:flutter/material.dart';

class UclBallBouncing extends StatefulWidget {
  const UclBallBouncing({super.key});

  @override
  UclBounce createState() => UclBounce();
}

class UclBounce extends State<UclBallBouncing>
    with SingleTickerProviderStateMixin {
  late AnimationController uclController;
  late Animation<double> bouncingAnim;
  bool isPlaying = true;
  bool isReversed = false;

  @override
  void initState() {
    super.initState();

    uclController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    bouncingAnim = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
          parent: uclController,
          curve: Curves.easeInOut
      ),
    );

    // Add a status listener to manage bouncing direction
    uclController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {  // when animation completes (ball reached bottom), reverse it
        uclController.reverse();
      } else if (status == AnimationStatus.dismissed) {  // when ball reached top, forward it
        uclController.forward();
      }
    });

    // ball bounces in the forward dir
    if (isReversed) {
      uclController.reverse(from: 1.0);
    } else {
      uclController.forward();
    }
  }

  @override
  /// Prof said we should use dispose even tho dart is a garbage collected language
  void dispose() {
    uclController.dispose();
    super.dispose();
  }

  /// Toggle between pausing and resuming the animation
  void pauseResumeFunc() {
    setState(() {
      if (isPlaying) {
        uclController.stop();
      } else {  // Resume the animation in the current direction
        if (isReversed) {
          uclController.reverse(from: uclController.value);
        } else {
          uclController.forward(from: uclController.value);
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
        uclController.stop();
        if (isReversed) {
          uclController.reverse(from: uclController.value);  // go anti-clockwise
        } else {
          uclController.forward(from: uclController.value);  // go clockwise
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height:30),
        Center(
          child: AnimatedBuilder(
            animation: bouncingAnim,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -bouncingAnim.value/3),  // divided by 3 to prevent pixel overflow in . Spoke to Prof after class
                child: child,
              );
            },
            child: Image.network(
              'https://images.footballfanatics.com/uefa/adidas-uefa-2024-champions-league-group-stage-mini-soccer-ball_ss5_p-200859588+pv-1+u-wr2roc9smeyqla6p7cmv+v-rsp6tf06oblq5mllgk5s.jpg?_hv=2&w=900',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
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
