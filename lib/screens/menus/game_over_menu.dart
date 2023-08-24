import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../games/gift_grab_game.dart';
import '../game_play.dart';
import 'menu_background_widget.dart';

class GameOverMenu extends StatelessWidget {
  final FruitsCollectorGame gameRef;
  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Game Over',
                style: TextStyle(
                  fontSize: Constants.isTablet ? 100 : 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Score: ${gameRef.score}',
                style: TextStyle(
                  fontSize: Constants.isTablet ? 100 : 50,
                ),
              ),
            ),
            SizedBox(
              width: Constants.isTablet ? 400 : 200,
              height: Constants.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.removeMenu(menu: Menu.gameOver);
                  gameRef.reset();
                  gameRef.resumeEngine();
                },
                child: Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: Constants.isTablet ? 50 : 25,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Constants.isTablet ? 400 : 200,
              height: Constants.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.removeMenu(menu: Menu.gameOver);
                  gameRef.reset();
                  gameRef.addMenu(menu: Menu.main);
                },
                child: Text(
                  'Main Menu',
                  style: TextStyle(
                    fontSize: Constants.isTablet ? 50 : 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
