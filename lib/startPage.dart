import 'dart:convert';
import 'package:flutter/material.dart';
import 'game.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;

class StartPage extends StatelessWidget {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Function to handle logout
  void logout(BuildContext context) async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'username');
    await storage.delete(key: 'first_name');
    await storage.delete(key: 'last_name');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> printAllValues() async {
    Map<String, String> allValues = await storage.readAll();
    allValues.forEach((key, value) {
      print('Key: $key, Value: $value');
    });
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final url = Uri.parse('http://77.243.80.52:8000/my_data/');
    String? token = await storage.read(key: "token");

    if (token == null) {
      throw Exception('Authorization token not found');
    }

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['data'] != null) {
        return responseData['data'] as Map<String, dynamic>;
      } else {
        throw Exception('User data not found');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _handleError(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              _handleError(context);
              return Text('You are not logged in.');
            } else if (snapshot.hasData) {
              String username = snapshot.data!['username'];
              String firstName = snapshot.data!['first_name'];
              String lastName = snapshot.data!['last_name'];
              storage.write(key: 'first_name', value: firstName);
              storage.write(key: 'username', value: username);
              storage.write(key: 'last_name', value: lastName);
              print(printAllValues());
              return Text('$firstName $lastName');
            } else {
              return Text('Start Page');
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TogyzQumalaqGame()),
                );
              },
              child: Text('Start Game'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => logout(context),
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Logout button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
