import 'package:flutter/material.dart';
import 'winnerPage.dart';
import 'drawPage.dart';
import 'dart:math';

class TogyzQumalaqGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Togyz Qumalaq Game'),
        ),
        body: TogyzQumalaqBoard(),
      ),
    );
  }
}

class TogyzKumalakAI {
  int playerNumber;
  int maxDepth;

  TogyzKumalakAI(this.playerNumber, [this.maxDepth = 3]);

  int findBestMove(_TogyzQumalaqBoardState currentGame) {
    int bestMove = 0;
    int bestValue = -999999999;

    for (var move in currentGame.getLegalMoves()) {
      currentGame.makeMove(move);
      var moveValue = minimax(currentGame, 0, false);
      currentGame.undoMove();

      if (moveValue > bestValue) {
        bestValue = moveValue;
        bestMove = move;
      }
    }

    return bestMove;
  }

  int minimax(
      _TogyzQumalaqBoardState currentGame, int depth, bool isMaximizingPlayer) {
    currentGame.checkMoves();
    if (depth == maxDepth) {
      return evaluateGameState(currentGame);
    }

    if (isMaximizingPlayer) {
      int maxEval = -999999999;
      for (var move in currentGame.getLegalMoves()) {
        currentGame.makeMove(move);
        var eval = minimax(currentGame, depth + 1, false);
        currentGame.undoMove();
        maxEval = max(maxEval, eval);
      }
      return maxEval;
    } else {
      int minEval = 999999999;
      for (var move in currentGame.getLegalMoves()) {
        currentGame.makeMove(move);
        var eval = minimax(currentGame, depth + 1, true);
        currentGame.undoMove();
        minEval = min(minEval, eval);
      }
      return minEval;
    }
  }

  int evaluateGameState(_TogyzQumalaqBoardState currentGame) {
    int score;

    // Basic evaluation based on Kazan
    if (currentGame.currentPlayer == 0) {
      score = -(currentGame.kazanPlayer[1] - currentGame.kazanPlayer[0]);
    } else {
      score = currentGame.kazanPlayer[1] - currentGame.kazanPlayer[0];
    }

    // Additional scoring for Tuzdyq control
    int tuzdyqValue =
        10; // Adjust this value based on the strategic value of Tuzdyq
    for (int player in [0, 1]) {
      if (currentGame.tuzdyq[player] != -1) {
        if (currentGame.currentPlayer == player) {
          score += tuzdyqValue;
        } else {
          score -= tuzdyqValue;
        }
      }
    }
    print(score);
    return score;
  }
}

// Helper classes like CurrentGame need to be defined in Dart as well.

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

  List<Map<String, dynamic>> history = [];

  TogyzKumalakAI gameAI = TogyzKumalakAI(1, 3);

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

  List<int> getLegalMoves() {
    List<int> legalMoves = [];
    for (int i = 0; i < 9; i++) {
      if (pitsPlayer[1][i] != 0) {
        legalMoves.add(i);
      }
    }
    return legalMoves;
  }

  Map<String, dynamic> saveState() {
    return {
      'pits': List<List<int>>.from(
          pitsPlayer.map((playerPits) => List<int>.from(playerPits))),
      'kazan': List<int>.from(kazanPlayer),
      'tuzdyq': List<int>.from(tuzdyq),
      'currentPlayer': currentPlayer,
    };
  }

  void undoMove() {
    if (history == List.empty()) {
      return;
    }
    Map<String, dynamic> last_state = history.removeLast();

    setState(() {
      pitsPlayer = last_state['pits'];
      kazanPlayer = last_state['kazan'];
      tuzdyq = last_state['tuzdyq'];
      currentPlayer = last_state['currentPlayer'];
    });
  }

  void makeMove(int pitIndex) {
    // Implement game logic here
    // Update pits, kazans, and currentPlayer accordingly
    checkMoves();

    Map<String, dynamic> state_before_move = saveState();
    history.add(state_before_move);

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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          Future.delayed(Duration(milliseconds: 3000), () {
                            makeMove(gameAI.findBestMove(this));
                            currentPlayer = (currentPlayer + 1) % 2;
                          });
                        });
                      } else
                        checkMoves();
                    },
                    child: Column(
                      children: [
                        Text('${i + 1}'),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
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
                // ElevatedButton(onPressed: undoMove, child: Text("Kenzh mal")),
              ],
            ),
            SizedBox(width: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 8; i >= 0; i--)
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
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
                Text('Kazan 2: ${kazanPlayer[1]}'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
