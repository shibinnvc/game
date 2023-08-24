import 'package:flutter/material.dart';

import 'package:flame/game.dart';

import 'data/constants/globals.dart';
import 'data/constants/screens.dart';
import 'data/services/hive_service.dart';
import 'presentation/games/gift_grab_game.dart';
import 'presentation/screens/game_over_screen.dart';
import 'presentation/screens/main_menu_screen.dart';

GiftGrabGame _giftGrabGame = GiftGrabGame();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.openHiveBox(boxName: 'settings');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          Globals.isTablet = MediaQuery.of(context).size.width > 600;

          return GameWidget(
            initialActiveOverlays: [Screens.main.name],
            game: _giftGrabGame,
            overlayBuilderMap: {
              Screens.gameOver.name:
                  (BuildContext context, GiftGrabGame gameRef) =>
                      GameOverMenu(gameRef: gameRef),
              Screens.main.name: (BuildContext context, GiftGrabGame gameRef) =>
                  MainMenu(gameRef: gameRef),
            },
          );
        },
      ),
    ),
  );
}
