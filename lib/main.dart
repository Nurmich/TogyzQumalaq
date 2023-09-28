import 'package:flatter_test/game.dart';
import 'package:flutter/material.dart';
import 'startPage.dart';

void main() => runApp(mainPage());

class mainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => StartPage(), // Define the route for the StartPage
        '/game': (context) => TogyzKumalakGame(), // Define the route for the game page
      },
    );
  }
}
