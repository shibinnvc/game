import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../fruit_collecting_game.dart';
import 'menus/game_over_menu.dart';
import 'menus/main_menu.dart';

FruitsCollectorGame _giftGrabGame = FruitsCollectorGame();

enum Menu { main, gameOver }

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      initialActiveOverlays: [Menu.main.name],
      game: _giftGrabGame,
      overlayBuilderMap: {
        Menu.gameOver.name:
            (BuildContext context, FruitsCollectorGame gameRef) =>
                GameOverMenu(gameRef: gameRef),
        Menu.main.name: (BuildContext context, FruitsCollectorGame gameRef) =>
            MainMenu(gameRef: gameRef),
      },
    );
  }
}
