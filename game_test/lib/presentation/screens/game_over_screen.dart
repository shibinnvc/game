import 'package:flutter/material.dart';

import '../../data/constants/globals.dart';
import '../../data/constants/screens.dart';
import '../games/gift_grab_game.dart';
import '../widgets/screen_background_widget.dart';

class GameOverMenu extends StatelessWidget {
  final GiftGrabGame gameRef;
  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Game Over',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 100 : 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Score: ${gameRef.score}',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 100 : 50,
                ),
              ),
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.removeMenu(menu: Screens.gameOver);
                  gameRef.reset();
                  gameRef.resumeEngine();
                },
                child: Text(
                  'Play Again?',
                  style: TextStyle(
                    fontSize: Globals.isTablet ? 50 : 25,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.removeMenu(menu: Screens.gameOver);
                  gameRef.reset();
                  gameRef.addMenu(menu: Screens.main);
                },
                child: Text(
                  'Main Menu',
                  style: TextStyle(
                    fontSize: Globals.isTablet ? 50 : 25,
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
