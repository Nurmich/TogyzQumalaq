import 'package:flutter/material.dart';
import 'game.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TogyzQumalaqGame()),
            );
          },
          child: Text('Start Game'),
        ),
      ),
    );
  }
}
