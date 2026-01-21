/*
I determined this animation to be an implicit animation based on the following criteria:

1. Animation must repeat indefinitely:
      -> False
         The background color transitions through a finite sequence of colors and stops after reaching the final color (e.g., Orange).

2. Animation is discontinuous (parts of animated widgets change position/size discontinuously):
      -> False
         The background color changes are smooth and continuous, providing a seamless transition without abrupt jumps.

3. Animation involves coordination among multiple objects:
      -> False
         The animation involves only a single text widget changing its background color, with no coordination required among multiple
         widgets or objects.

Since none of the conditions above are true, I have used an implicit animation.
*/

import 'package:flutter/material.dart';

class TextChangingBackgroundColor extends StatefulWidget {
  final Function(String status)? status;

  const TextChangingBackgroundColor({Key? key, this.status})
      : super(key: key);

  @override
  _TextChangingBackgroundColorState createState() =>
      _TextChangingBackgroundColorState();
}

class _TextChangingBackgroundColorState
    extends State<TextChangingBackgroundColor> {
  final List<Color> colors = [Colors.red, Colors.blue, Colors.orange];
  int currPos = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startColourChange();
    });
  }

  /// anim has started
  void startColourChange() async {
    if (widget.status != null) {
      widget.status!('playing');
    }

    // Transition from Red to Blue. prof taught await during testing in class
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      currPos = 1;
    });

    // Transition from Blue to Orange
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      currPos = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      color: colors[currPos],
      width: 300,
      height: 100,
      alignment: Alignment.center,
      onEnd: () {
        // anim status is completed once the color is completely orange. before i had the status as completed once the final transition began (so when orange color starts to blend w/ blue)
        if (currPos == colors.length - 1 && widget.status != null) {
          widget.status!('completed');
        }
      },
      child: const Text(
        'Another one!!!',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
