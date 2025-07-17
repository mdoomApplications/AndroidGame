import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/game_provider.dart';
import 'screens/name_input_screen.dart';
import 'screens/hatching_screen.dart';
import 'screens/main_game_screen.dart';
import 'screens/game_over_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Dragon Tamagotchi',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: GameWrapper(),
      ),
    );
  }
}

class GameWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        switch (gameProvider.gamePhase) {
          case GamePhase.nameInput:
            return NameInputScreen();
          case GamePhase.hatching:
            return HatchingScreen();
          case GamePhase.playing:
            return MainGameScreen();
          case GamePhase.gameOver:
            return GameOverScreen();
          default:
            return NameInputScreen();
        }
      },
    );
  }
}