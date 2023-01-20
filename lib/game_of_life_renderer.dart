import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'game_of_life.dart';

class GameOfLifeRenderer extends StatefulWidget {
  const GameOfLifeRenderer({super.key, required this.game});
  final Game game;

  @override
  State<GameOfLifeRenderer> createState() => _GameOfLifeRendererState();
}

class _GameOfLifeRendererState extends State<GameOfLifeRenderer>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  var _tickCount = 0;

  Game get game => widget.game;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      _tickCount++;
      if (_tickCount % 5 == 0) {
        setState(() => game.tick());
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: game.grid.xCount / game.grid.yCount,
      child: SizedBox(
        // pass double.infinity to prevent shrinking of the painter area to 0.
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(painter: GameOfLifePainter(game)),
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
    for (var entry in game.grid.field.entries) {
      final point = entry.key;
      if (entry.value) {
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
  bool shouldRepaint(GameOfLifePainter oldDelegate) => true;
}
