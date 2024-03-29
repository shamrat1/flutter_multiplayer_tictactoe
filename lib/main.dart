import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tic_tac_toe/screens/lobby_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: Colors.purple,
          textTheme: GoogleFonts.pressStart2pTextTheme(),
          dialogTheme: DialogTheme(
            backgroundColor: Colors.black,
            titleTextStyle:
                GoogleFonts.pressStart2pTextTheme().bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
            contentTextStyle:
                GoogleFonts.pressStart2pTextTheme().bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
          )),
      home: LobbyScreen(),
    );
  }
}
