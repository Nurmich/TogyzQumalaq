import 'package:flutter/material.dart';

class WinnerPage extends StatelessWidget {
  final String winnerName;
  final Function resetGame;

  WinnerPage(this.winnerName, this.resetGame);

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
              'Winner: $winnerName',
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
