import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/firestore_service.dart';
import 'package:tic_tac_toe/game_state.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, this.gameId, this.playOnline = false});
  final String? gameId;
  final bool playOnline;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String appName = "TicTacToe";
  GameState? _gameState;
  var width = 0.0;
  var height = 0.0;
  String? _gameID;
  FirestoreService? _firestoreService;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _gameStream;

  @override
  void initState() {
    super.initState();
    if (widget.playOnline) {
      _gameID = widget.gameId ?? (Random().nextInt(9998) + 1).toString();
      _firestoreService = FirestoreService(docID: _gameID!);
      if (widget.gameId == null) {
        _gameState = GameState(
          playerOneStatus: "joined",
          playerTwoStatus: null,
          gameID: _gameID,
          currentTurn: Random().nextInt(2) + 1,
          state: [
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
          ],
          results: [],
        );
        _firestoreService?.addData(_gameState?.toJson()).then((value) {
          _gameStream = _firestoreService?.gameStream();
          _startStreamListener();
        });
      } else {
        _firestoreService?.getGame().then((game) {
          _gameState = game;
          _firestoreService!
              .updateData(
                  _gameState?.copyWith(playerTwoStatus: "joined").toJson())
              .then((value) {
            print("Player two joined");
            _gameStream = _firestoreService?.gameStream();
            setState(() {});
            _startStreamListener();
          });
        });
      }
    } else {
      _gameState = GameState(
        currentTurn: Random().nextInt(2) + 1,
        playerOneStatus: "joined",
        playerTwoStatus: "joined",
        state: [
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
        ],
        results: [],
      );
    }
  }

  void _startStreamListener() {
    print(_gameStream);
    _gameStream?.listen(
      (data) {
        print("Listening to changes");
        print(data.data());
        _gameState = GameState.fromJson(data.data() ?? {});
        setState(() {});
        _checkWinner();
      },
      onError: (e) {
        print(e);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("TicTacToe"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: (height * 0.10),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _playerScoreBoard("Player 1", _gameState?.currentTurn == 1,
                      _gameState?.results.where((e) => e == "1").length ?? 0),
                  _playerScoreBoard("Player 2", _gameState?.currentTurn == 2,
                      _gameState?.results.where((e) => e == "2").length ?? 0),
                ],
              ),
            ),
            if (_gameID != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Game ID: $_gameID"),
              ),
            SizedBox(
              height: (height * 0.15) * 3,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: (height * 0.15),
                  ),
                  itemCount: 9,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () => _onTileTapped(i),
                      child: Container(
                        width: width * 0.20,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _gameState?.state[i] ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    );
                  }),
            ),
            if (_gameState != null && _gameState!.playerTwoStatus == null)
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "Wait Till Player Two Joins",
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _playerScoreBoard(String player, bool turn, int win) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < 3; i++)
              Icon(
                Icons.star_rounded,
                color: i < win ? Colors.amber : Colors.grey,
              ),
          ],
        ),
        Text(
          player,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: turn ? Colors.black : Colors.grey.shade300,
              ),
        ),
      ],
    );
  }

  void _onTileTapped(int i) {
    if (_gameState == null) return;
    if (_gameState!.playerTwoStatus == null) return;

    if (_gameState!.state[i] != "") return;
    var currentTurn = _gameState!.currentTurn;
    var state = _gameState!.state;
    state[i] = currentTurn == 1 ? "X" : "0";
    currentTurn = currentTurn == 1 ? 2 : 1;
    var gameState = _gameState!.copyWith(
      currentTurn: currentTurn,
      state: state,
    );
    if (widget.playOnline) {
      _firestoreService!.addData(gameState.toJson());
    } else {
      _gameState = gameState;
      setState(() {});
    }
  }

  void _checkWinner() {
    if (_gameState == null) return;
    var state = _gameState!.state;

    for (int i = 0; i < 3; i++) {
      if (state[i * 3] == state[i * 3 + 1] &&
          state[i * 3] == state[i * 3 + 2] &&
          state[i * 3] != "") {
        _showWinDialog();
        return;
      }
    }

    // Columns
    for (int i = 0; i < 3; i++) {
      if (state[i] == state[i + 3] &&
          state[i] == state[i + 6] &&
          state[i] != "") {
        _showWinDialog();
        return;
      }
    }

    // Diagonals
    if (state[0] == state[4] && state[0] == state[8] && state[0] != "") {
      _showWinDialog();
      return;
    }
    if (state[2] == state[4] && state[2] == state[6] && state[2] != "") {
      _showWinDialog();
      return;
    }
  }

  _showWinDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Winn"),
      ),
    );
  }
}
