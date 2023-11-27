import 'package:flutter/material.dart';
import 'package:togyz_qumalaq/difficultyPage.dart';

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
