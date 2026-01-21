// image_enlarging_shrinking.dart

/*
I determined this animation to be an implicit animation based on the following from the slides:

1. Animation must repeat indefinitely:
      -> False
         The image enlarges to a specified size and then shrinks back to its original size a finite number of times before stopping.

2. Animation is discontinuous (parts of animated widgets change position/size discontinuously):
      -> False
         The image's size changes are smooth and continuous, providing a seamless enlarging and shrinking effect without abrupt jumps.

3. Animation involves coordination among multiple objects:
      -> False
         The animation involves only a single image widget resizing within its container, with no coordination required among multiple
         widgets or objects.

Since none of the conditions above are true, I have used an implicit animation.
*/

import 'package:flutter/material.dart';

class ImageEnlargingShrinking extends StatefulWidget {
  final Function(String status)? status;

  const ImageEnlargingShrinking({Key? key, this.status})
      : super(key: key);

  @override
  _ImageEnlargingShrinkingState createState() =>
      _ImageEnlargingShrinkingState();
}

class _ImageEnlargingShrinkingState extends State<ImageEnlargingShrinking> {
  bool isEnlarged = false;

  void toggleSize() {
    setState(() {
      isEnlarged = !isEnlarged;
    });

    // anim has started
    if (widget.status != null) {
      widget.status!('playing');
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = isEnlarged ? 150 : 75;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(  // as prof said, this is used for an implicit animation
          width: size,
          height: size,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
          child: Image.network(
            'https://uploads.dailydot.com/2024/06/DJ-Khaled-Life-is-Roblox-TikTok.png?auto=compress&fm=png',
            fit: BoxFit.cover,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
          ),
          onEnd: () {
            // animation is complete now so need to show the status in the appbar
            if (widget.status != null) {
              widget.status!('complete');
            }
          },
        ),
        // const SizedBox(height: 20),
        // Toggle Button
        ElevatedButton(
          onPressed: toggleSize,
          child: Text(isEnlarged ? 'Shrink Image' : 'Enlarge Image'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
