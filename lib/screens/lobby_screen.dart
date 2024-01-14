import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/widgets/button_widget.dart';

class LobbyScreen extends StatelessWidget {
  LobbyScreen({super.key});
  final TextEditingController _gameIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Text(
              "TicTacToe",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GameButtonWidget(
              title: "Play Offline",
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const GamePage(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GameButtonWidget(
              title: "Play With Friends",
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const GamePage(
                    playOnline: true,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GameButtonWidget(
              title: "Join Game With ID",
              onTap: () {
                showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog.adaptive(
                        title: const Text("Enter Game ID to Join"),
                        content: TextFormField(
                          controller: _gameIdController,
                          decoration: const InputDecoration(
                              label: Text("Game ID"),
                              border: OutlineInputBorder()),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Dismiss"),
                          ),
                          TextButton(
                            onPressed: () {
                              print(_gameIdController.text.isEmpty);
                              if (_gameIdController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Enter Game ID to proceed."),
                                  ),
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => GamePage(
                                    gameId: _gameIdController.text,
                                    playOnline: true,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Join"),
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ]),
      ),
    );
  }
}
