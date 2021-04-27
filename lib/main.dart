import 'package:flutter/material.dart';
import 'package:game_of_life_flutter/game_of_life_renderer.dart';

import 'game_of_life.dart';
import 'game_of_life.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color darkBlue = Color.fromARGB(255, 18, 32, 47);
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: GameSelector(),
    );
  }
}

class GameSelector extends StatefulWidget {
  @override
  _GameSelectorState createState() => _GameSelectorState();
}

class _GameSelectorState extends State<GameSelector> {
  var _currentGameIndex = 0;

  void _nextGame() {
    setState(() {
      _currentGameIndex = (_currentGameIndex + 1) % Patterns.allGrids.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Outer white container with padding
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: GameOfLifeRenderer(
          game: Game(Patterns.allGrids[_currentGameIndex]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextGame,
        child: Icon(
          Icons.play_arrow_rounded,
        ),
      ),
    );
  }
}
