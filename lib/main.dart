import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String appName = "TicTacToe";
  int currentTurn = 1;
  List<String> _state = ["", "", "", "", "", "", "", "", ""];
  var width = 0.0;
  var height = 0.0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _state = ["", "", "", "", "", "", "", "", ""];
          });
        },
      ),
      body: Column(
        children: [
          _playerWidget("Player 1", currentTurn == 1),
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
                        _state[i].toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  );
                }),
          ),
          _playerWidget("Player 2", currentTurn == 2),
        ],
      ),
    );
  }

  Widget _playerWidget(String title, bool active) {
    return Container(
      height: (height * 0.15),
      margin: EdgeInsets.symmetric(vertical: (height * 0.02)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primaryContainer,
        border: active
            ? Border.all(
                color: Theme.of(context).colorScheme.background, width: 10)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
    );
  }

  void _onTileTapped(int i) {
    if (_state[i] != "") return;

    _state[i] = currentTurn == 1 ? "X" : "0";
    currentTurn = currentTurn == 1 ? 2 : 1;
    setState(() {});
    _checkWinner();
  }

  void _checkWinner() {
    // Rows
    for (int i = 0; i < 3; i++) {
      if (_state[i * 3] == _state[i * 3 + 1] &&
          _state[i * 3] == _state[i * 3 + 2] &&
          _state[i * 3] != "") {
        _showWinDialog();
        return;
      }
    }

    // Columns
    for (int i = 0; i < 3; i++) {
      if (_state[i] == _state[i + 3] &&
          _state[i] == _state[i + 6] &&
          _state[i] != "") {
        _showWinDialog();
        return;
      }
    }

    // Diagonals
    if (_state[0] == _state[4] && _state[0] == _state[8] && _state[0] != "") {
      _showWinDialog();
      return;
    }
    if (_state[2] == _state[4] && _state[2] == _state[6] && _state[2] != "") {
      _showWinDialog();
      return;
    }
  }

  _showWinDialog() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Winn")));
  }
}
