/*
I determined this animation to be an implicit animation based on the following criteria:

1. Animation must repeat indefinitely:
      -> False
         The icon moves through a finite sequence of positions (Top-Left → Top-Right → Bottom-Right → Bottom-Left) and stops after reaching the final position.

2. Animation is discontinuous (parts of animated widgets change position/size discontinuously):
      -> False
         The icon's movement is smooth and continuous, providing a seamless transition between positions.

3. Animation involves coordination among multiple objects:
      -> False
         The animation involves only a single icon moving within its container, with no coordination required among multiple widgets or objects.

Since none of the conditions above are true, I have used an implicit animation.
*/

import 'package:flutter/material.dart';

class MovingIcon extends StatefulWidget {
  final Function(String status)? status;

  const MovingIcon({Key? key, this.status}) : super(key: key);

  @override
  _MovingIconState createState() => _MovingIconState();
}

class _MovingIconState extends State<MovingIcon> {
  final List<Alignment> alignments = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
  ];

  int currPos = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      iconMovement();
    });
  }

  void iconMovement() async {
    for (int i = 1; i < alignments.length; i++) {
      if (widget.status != null) {
        widget.status!('playing');
        // print('MovingIcon animation is playing');
      }

      // wait for the animation to reach the next position. prof spoke about await when he taught about testing
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        currPos = i;
      });
    }

    // After reaching the last position, update status to completed.  prof taught await during testing in class
    await Future.delayed(const Duration(seconds: 2));
    if (widget.status != null) {
      widget.status!('completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.grey[300],
      child: AnimatedAlign(
        alignment: alignments[currPos],
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        child: const Icon(
          Icons.ramen_dining,
          size: 40,
          color: Colors.red,
        ),
      ),
    );
  }
}