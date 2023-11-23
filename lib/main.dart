import 'package:togyz_qumalaq/game.dart';
import 'package:flutter/material.dart';
import 'startPage.dart';

class mainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => StartPage(), // Define the route for the StartPage
        '/game': (context) =>
            TogyzQumalaqGame(), // Define the route for the game page
      },
    );
  }
}
