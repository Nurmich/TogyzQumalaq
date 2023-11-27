import 'package:flutter/material.dart';
import 'package:togyz_qumalaq/difficultyPage.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DifficultyPage()),
                );
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
