import 'package:flutter/material.dart';
import 'winnerPage.dart';
import 'drawPage.dart';

class TogyzQumalaqGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Togyz Qumalaq Game'),
        ),
        body: TogyzQumalaqBoard(),
      ),
    );
  }
}

class TogyzQumalaqBoard extends StatefulWidget {
  @override
  _TogyzQumalaqBoardState createState() => _TogyzQumalaqBoardState();
}

class _TogyzQumalaqBoardState extends State<TogyzQumalaqBoard> {
  List<List<int>> pitsPlayer =
      List.generate(2, (index) => List.generate(9, (index) => 9));
  // List<int> pitsPlayer1 = List.generate(9, (index) => 9); // Player 1's pits
  // List<int> pitsPlayer2 = List.generate(9, (index) => 9); // Player 2's pits
  List<int> kazanPlayer = List.generate(2, (index) => 0);
  int currentPlayer = 0;
  List<int> tuzdyq = List.generate(2, (index) => -1);

  void resetGame() {
    setState(() {
      // Reset all game-related variables to their initial state
      pitsPlayer = List.generate(2, (index) => List.generate(9, (index) => 9));
      kazanPlayer = List.generate(2, (index) => 0);
      currentPlayer = 0;
      tuzdyq = List.generate(2, (index) => -1);
    });
  }

  void gameEnd() {
    String winnerName;
    if (kazanPlayer[0] > kazanPlayer[1]) {
      winnerName = "Player 1";
    } else if (kazanPlayer[0] < kazanPlayer[1]) {
      winnerName = "Player 2";
    } else {
      winnerName = "Draw";
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => DrawPage(resetGame)));
    }
    if (winnerName != "Draw")
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WinnerPage(winnerName, resetGame)));
  }

  void checkMoves() {
    bool end = true;
    for (int i = 0; i < 9; i++) {
      if (pitsPlayer[currentPlayer][i] > 0) end = false;
    }
    if (end == true) {
      kazanPlayer[(currentPlayer + 1) % 2] += (162 -
          kazanPlayer[currentPlayer] -
          kazanPlayer[(currentPlayer + 1) % 2]);
      gameEnd();
    }
  }

  void makeMove(int pitIndex) {
    // Implement game logic here
    // Update pits, kazans, and currentPlayer accordingly
    checkMoves();
    int temp = pitsPlayer[currentPlayer][pitIndex];
    int tempPlayer = currentPlayer;
    pitsPlayer[tempPlayer][pitIndex] = 0;
    if (temp == 1) {
      if (pitIndex == 8) {
        if (tuzdyq[(currentPlayer + 1) % 2] == 0) {
          kazanPlayer[currentPlayer]++;
        } else {
          pitsPlayer[(currentPlayer + 1) % 2][0]++;
          tempPlayer = (currentPlayer + 1) % 2;
          pitIndex = 0;
        }
      } else {
        if (tuzdyq[currentPlayer] == pitIndex + 1)
          kazanPlayer[(currentPlayer + 1) % 2]++;
        else {
          pitsPlayer[currentPlayer][pitIndex + 1]++;
          pitIndex++;
        }
      }
      temp = 0;
    }
    while (temp > 0) {
      if (pitIndex == 9) {
        tempPlayer = (tempPlayer + 1) % 2;
        pitIndex %= 9;
      }
      if (pitIndex == tuzdyq[tempPlayer]) {
        kazanPlayer[(tempPlayer + 1) % 2]++;
        temp--;
        if (temp > 0) pitIndex++;
        continue;
      }
      pitsPlayer[tempPlayer][pitIndex]++;
      temp--;
      if (temp == 0) continue;
      pitIndex++;
    }
    if (tempPlayer != currentPlayer) {
      if (pitsPlayer[tempPlayer][pitIndex] == 3 &&
          pitIndex != 8 &&
          tuzdyq[(tempPlayer + 1) % 2] != pitIndex &&
          tuzdyq[tempPlayer] == -1) {
        tuzdyq[tempPlayer] = pitIndex;
        kazanPlayer[currentPlayer] += pitsPlayer[tempPlayer][pitIndex];
        pitsPlayer[tempPlayer][pitIndex] = 0;
      } else if (pitsPlayer[tempPlayer][pitIndex] % 2 == 0) {
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
                          pitsPlayer[currentPlayer][i] > 0) {
                        makeMove(i);
                        // Call your game logic function
                        // After the move, toggle the currentPlayer
                        if (kazanPlayer[0] > 81 || kazanPlayer[1] > 81)
                          gameEnd();
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
                            color: i == tuzdyq[0] ? Colors.red : Colors.white,
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
                          pitsPlayer[currentPlayer][i] > 0) {
                        makeMove(i);
                        if (kazanPlayer[0] > 81 || kazanPlayer[1] > 81)
                          gameEnd();
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
                            color: i == tuzdyq[1] ? Colors.red : Colors.white,
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
