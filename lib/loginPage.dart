import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:togyz_qumalaq/main.dart';
import 'package:togyz_qumalaq/registerPage.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFFCA854E)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  // Function to handle login
  Future<void> login(BuildContext context) async {
    var url = Uri.parse(
        'http://77.243.80.52:8000/login/'); // Replace with your API endpoint
    try {
      var response = await http.post(
        url,
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );
      if (response.statusCode == 200) {
        var token = json.decode(response.body)['access'];
        print(token);
        await storage.write(key: 'token', value: token);
        // Navigate to the HomeScreen if login is successful
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => mainPage()),
        );
      } else {
        print('Failed to log in');
        // Show an error message
        _showErrorDialog(context, 'Failed to log in');
      }
    } catch (e) {
      print('Error occurred while logging in: $e');
      _showErrorDialog(context, e.toString());
    }
  }

  // Function to show an error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.height * 0.02;
    final double buttonWidth = screenSize.width * 0.8;
    final double buttonHeight = screenSize.height * 0.06;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Use the minimum space needed by children
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Logo placeholder
                Image.asset(
                  'assets/in_app_logo.png',
                  height: screenSize.height * 0.1, // Adjust the size as needed
                ),
                SizedBox(height: padding),
                Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding),
                Text(
                  'Login to continue battle',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding * 2),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: padding * 2),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: padding * 2),
                ElevatedButton(
                    child: Text('Let\'s Combat!'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFCA854E),
                      onPrimary: Colors.white,
                      minimumSize: Size(buttonWidth, buttonHeight),
                    ),
                    onPressed: () => login(context)),
                SizedBox(height: padding),
                Text(
                  'Connect With:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: padding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.login), // Placeholder for Google icon
                      onPressed: () {
                        // Implement Google Sign-In functionality
                      },
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.facebook), // Placeholder for Facebook icon
                      onPressed: () {
                        // Implement Facebook Sign-In functionality
                      },
                    ),
                  ],
                ),
                SizedBox(height: padding),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Color(0xFFCA854E),
                      minimumSize: Size(buttonWidth, buttonHeight),
                    ),
                    child: Text('Don\'t have an account? Create Account'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
