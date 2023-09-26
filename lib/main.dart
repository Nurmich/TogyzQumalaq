import 'package:flutter/material.dart';

void main() => runApp(TogyzKumalakGame());

class TogyzKumalakGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Togyz Kumalak Game'),
        ),
        body: TogyzKumalakBoard(),
      ),
    );
  }
}

class TogyzKumalakBoard extends StatefulWidget {
  @override
  _TogyzKumalakBoardState createState() => _TogyzKumalakBoardState();
}

class _TogyzKumalakBoardState extends State<TogyzKumalakBoard> {
  List<int> pitsPlayer1 = List.generate(9, (index) => 9); // Player 1's pits
  List<int> pitsPlayer2 = List.generate(9, (index) => 9); // Player 2's pits
  int kazanPlayer1 = 0;
  int kazanPlayer2 = 0;
  int currentPlayer = 1;

  void makeMove(int pitIndex) {
    // Implement game logic here
    // Update pits, kazans, and currentPlayer accordingly
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Player $currentPlayer\'s Turn'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                for (int i = 0; i < 9; i++)
                  GestureDetector(
                    onTap: () {
                      if (currentPlayer == 1 && pitsPlayer1[i] > 0) {
                        makeMove(i);
                        // Call your game logic function
                        // After the move, toggle the currentPlayer
                        setState(() {
                          currentPlayer = 2;
                        });
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          pitsPlayer1[i].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                Text('Kazan 1: $kazanPlayer1'),
              ],
            ),
            SizedBox(width: 20),
            Column(
              children: [
                for (int i = 0; i < 9; i++)
                  GestureDetector(
                    onTap: () {
                      if (currentPlayer == 2 && pitsPlayer2[i] > 0) {
                        makeMove(i);
                        // Call your game logic function
                        // After the move, toggle the currentPlayer
                        setState(() {
                          currentPlayer = 1;
                        });
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          pitsPlayer2[i].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                Text('Kazan 2: $kazanPlayer2'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
