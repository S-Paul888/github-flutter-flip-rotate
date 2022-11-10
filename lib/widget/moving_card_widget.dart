// ignore_for_file: unused_import

import 'dart:math';

import 'package:flutter/material.dart';

class MovingCardWidget extends StatefulWidget {
  final String urlFront;
  final String urlBack;

  const MovingCardWidget(
      {required this.urlFront, required this.urlBack, super.key});

  @override
  State<MovingCardWidget> createState() => _MovingCardWidgetState();
}

class _MovingCardWidgetState extends State<MovingCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  bool isFront = true;
  double vericalDrag = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onVerticalDragStart: (details) {
          controller.reset();
          setState(() {
            isFront = true;
            vericalDrag = 0;
          });
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            vericalDrag += details.delta.dy;
            vericalDrag %= 360;

            setImageside();
          });
        },
        onVerticalDragEnd: (details) {
          final double end = 360 - vericalDrag >= 180 ? 0 : 360;
          animation =
              Tween<double>(begin: vericalDrag, end: end).animate(controller)
                ..addListener(() {
                  setState(() {
                    vericalDrag = animation.value;
                    setImageside();
                  });
                });
          controller.forward();
        },
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(vericalDrag / 180 * pi),
          alignment: Alignment.center,
          child: isFront
              ? Image.asset(widget.urlFront)
              : Transform(
                  transform: Matrix4.identity()..rotateX(pi),
                  alignment: Alignment.center,
                  child: Image.asset(widget.urlBack),
                ),
        ),
      );
  void setImageside() {
    if (vericalDrag <= 90 || vericalDrag >= 270) {
      isFront = true;
    } else {
      isFront = false;
    }
  }
}
