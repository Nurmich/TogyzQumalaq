import 'package:flutter/material.dart';


class DrawPage extends StatelessWidget {
  final Function resetGame;

  DrawPage(this.resetGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game End Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Friendship wins!',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset game state here (score, board, etc.)
                // You can call a function to reset the game state
                resetGame();
                // Navigate back to the game page
                Navigator.pop(context);
              },
              child: Text('Restart Game'),
            ),
            // Add any other content you want to display on this page
          ],
        ),
      ),
    );
  }
}

