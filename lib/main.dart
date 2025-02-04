import 'package:togyz_qumalaq/game.dart';
import 'package:togyz_qumalaq/loginPage.dart';
import 'package:flutter/material.dart';
import 'startPage.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(MyApp());
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  });
}

class mainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/': (context) => StartPage(), // Define the route for the StartPage
      },
    );
  }
}
