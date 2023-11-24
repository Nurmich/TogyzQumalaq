import 'package:flutter/material.dart';
import 'game.dart';

class DifficultyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Difficulty'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => navigateToGame(context, 1), // Easy
              child: Text('Easy'),
            ),
            ElevatedButton(
              onPressed: () => navigateToGame(context, 2), // Medium
              child: Text('Medium'),
            ),
            ElevatedButton(
              onPressed: () => navigateToGame(context, 3), // Hard
              child: Text('Hard'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToGame(BuildContext context, int difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TogyzQumalaqGame(difficulty: difficulty),
      ),
    );
  }
}
