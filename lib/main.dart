import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_of_life_flutter/game_of_life.dart';

void main() {
  runApp(MyApp());
}

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer _timer;
  final game = Game(Patterns.gosperGliderGun());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 40),
      (_) => setState(() => game.tick()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // Outer white container with padding
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          child: LayoutBuilder(
            builder: (_, __) => AspectRatio(
              aspectRatio: game.grid.xCount / game.grid.yCount,
              child: Container(
                // pass double.infinity to prevent shrinking of the painter area to 0.
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(painter: GameOfLifePainter(game)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameOfLifePainter extends CustomPainter {
  GameOfLifePainter(this.game);
  final Game game;

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final linesPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.red;

    final boxPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;

    final dx = size.width / game.grid.xCount;
    final dy = size.height / game.grid.yCount;
    // Active cells
    for (var point in game.grid.field.keys) {
      if (game.grid.field[point]) {
        final rect = Rect.fromLTWH(point.x * dx, point.y * dy, dx, dy);
        canvas.drawRect(rect, boxPaint);
      }
    }
    // grid
    for (var x = 0; x <= game.grid.xCount; x++) {
      for (var y = 0; y <= game.grid.yCount; y++) {
        final xPath = Path();
        xPath.moveTo(x * dx, 0);
        xPath.lineTo(x * dx, size.height);

        final yPath = Path();
        yPath.moveTo(0, y * dy);
        yPath.lineTo(size.width, y * dy);

        canvas.drawPath(xPath, linesPaint);
        canvas.drawPath(yPath, linesPaint);
      }
    }
  }

  @override
  bool shouldRepaint(GameOfLifePainter oldDelegate) => false;
}
