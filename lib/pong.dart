import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  State<Pong> createState() => _PongState();
}

Direction vDir = Direction.down;
Direction hDir = Direction.right;

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double randX = 1;
  double randY = 1;
  int score = 0;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  double increment = 5;
  Animation<double>? animation;
  AnimationController? controller;
  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(
        seconds: 10000,
      ),
      vsync: this,
    );
    // set linear interpolation between (Tween) a begining and ending value
    animation = Tween<double>(begin: 0, end: 100).animate(controller!);
    animation?.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX = ((increment * randX).roundToDouble())
            : posX = ((increment * randX).roundToDouble());
        (vDir == Direction.down)
            ? posY = ((increment * randY).roundToDouble())
            : posY = ((increment * randY).roundToDouble());
      });
      checkBorders();
    });
    controller?.forward();
    super.initState();
  }

  double? width;
  double? height;
  double? posX = 0;
  double? posY = 0;
  double? batWidth = 0;
  double? batHeight = 0;
  double? batPosition = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width! / 5;
      batHeight = height! / 20;
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Positioned(top: 0, right: 24, child: Text('Score: $score')),
          ),
          Positioned(
            top: posY,
            left: posX,
            child: const Ball(),
          ),
          Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                child: Bat(batWidth!, batHeight!),
              ))
        ],
      );
    });
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: const Text('Would you like to play again?'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Yes'),
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  Navigator.of(context).pop();
                  controller?.repeat();
                },
              ),
              ElevatedButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void checkBorders() {
    double diameter = 50;

    if (posX! <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX! >= width! - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY! >= height! - diameter - batHeight! && vDir == Direction.down) {
      // check if the bat is here, otherwise the game is over
      if (posX! >= (batPosition! - diameter) &&
          posX! <= (batPosition! + batWidth! + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
      } else {
        controller!.stop();
        showMessage(context);
      }
    }
    if (posY! <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
    if (posX! >= (batPosition! - diameter) &&
        posX! <= (batPosition! + batWidth! + diameter)) {
      vDir = Direction.up;
      randY = randomNumber();
      safeSetState(() {
        score++;
      });
    }
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition = update.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller!.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double randomNumber() {
    // this is a number between 0.5 and 1.5
    //to initialize the ball in a random position
    var ran = Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }
}
