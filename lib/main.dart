import 'package:flutter/material.dart';
import 'package:game_of_life_flutter/game_of_life_renderer.dart';

import 'game_of_life.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color.fromARGB(255, 18, 32, 47);
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: const GameSelector(),
    );
  }
}

class GameSelector extends StatefulWidget {
  const GameSelector({super.key});

  @override
  State<GameSelector> createState() => _GameSelectorState();
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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: GameOfLifeRenderer(
          game: Game(Patterns.allGrids[_currentGameIndex]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton(
        onPressed: _nextGame,
        child: Text(
          Patterns.names[_currentGameIndex],
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
