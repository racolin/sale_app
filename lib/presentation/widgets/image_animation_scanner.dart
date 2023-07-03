import 'package:flutter/material.dart';

class ImageScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;

  ImageScannerAnimation(this.stopped, this.width,
      {Key? key, Animation<double>? animation})
      : super(key: key, listenable: animation!);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final scorePosition = (animation.value * 260);

    Color color1 = const Color.fromRGBO(37, 99, 235, 0.26);
    Color color2 = const Color.fromRGBO(37, 99, 235, 0);

    if (animation.status == AnimationStatus.reverse) {
      color1 = const Color.fromRGBO(37, 99, 235, 0.26);
      color2 = const Color.fromRGBO(37, 99, 235, 0);
    }

    return Positioned(
      bottom: scorePosition,
      child: Opacity(
        opacity: (stopped) ? 0.0 : 1.0,
        child: Column(
          children: [
            Container(
              height: 6.0,
              width: 270.5,
              color: const Color.fromRGBO(3, 58, 175, 1),
            ),
            Container(
              height: 67.0,
              width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 0.9],
                colors: [color1, color2],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
