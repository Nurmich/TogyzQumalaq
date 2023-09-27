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
  List<List<int>> pitsPlayer =
      List.generate(2, (index) => List.generate(9, (index) => 9));
  // List<int> pitsPlayer1 = List.generate(9, (index) => 9); // Player 1's pits
  // List<int> pitsPlayer2 = List.generate(9, (index) => 9); // Player 2's pits
  List<int> kazanPlayer = List.generate(2, (index) => 0);
  int currentPlayer = 0;

  void makeMove(int pitIndex) {
    // Implement game logic here
    // Update pits, kazans, and currentPlayer accordingly
    int temp = pitsPlayer[currentPlayer][pitIndex];
    int tempPlayer = currentPlayer;
    pitsPlayer[tempPlayer][pitIndex] = 0;
    while (temp > 0) {
      if (pitIndex == 9) {
        tempPlayer = (tempPlayer + 1) % 2;
        pitIndex %= 9;
      }
      pitsPlayer[tempPlayer][pitIndex]++;
      temp--;
      if (temp == 0) continue;
      pitIndex++;
    }
    if (tempPlayer != currentPlayer) {
      if (pitsPlayer[tempPlayer][pitIndex] % 2 == 0) {
        kazanPlayer[currentPlayer] += pitsPlayer[tempPlayer][pitIndex];
        pitsPlayer[tempPlayer][pitIndex] = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Player ${currentPlayer + 1}\'s Turn'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                for (int i = 0; i < 9; i++)
                  GestureDetector(
                    onTap: () {
                      if (currentPlayer == 0 &&
                          pitsPlayer[currentPlayer][i] > 1) {
                        makeMove(i);
                        // Call your game logic function
                        // After the move, toggle the currentPlayer
                        setState(() {
                          currentPlayer = (currentPlayer + 1) % 2;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text('${i + 1}'),
                        Container(
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
                              pitsPlayer[0][i].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Text('Kazan 1: ${kazanPlayer[0]}'),
              ],
            ),
            SizedBox(width: 20),
            Column(
              children: [
                for (int i = 8; i >= 0; i--)
                  GestureDetector(
                    onTap: () {
                      if (currentPlayer == 1 &&
                          pitsPlayer[currentPlayer][i] > 1) {
                        makeMove(i);
                        // Call your game logic function
                        // After the move, toggle the currentPlayer
                        setState(() {
                          currentPlayer = (currentPlayer + 1) % 2;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Container(
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
                              pitsPlayer[1][i].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Text('${i + 1}')
                      ],
                    ),
                  ),
                Text('Kazan 2: ${kazanPlayer[1]}'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
