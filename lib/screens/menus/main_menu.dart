import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../games/gift_grab_game.dart';
import '../game_play.dart';
import 'menu_background_widget.dart';

class MainMenu extends StatelessWidget {
  final FruitsCollectorGame gameRef;
  const MainMenu({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

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
                'Fruit Collector',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: Constants.isTablet ? 100 : 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: Constants.isTablet ? 400 : 200,
              height: Constants.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.removeMenu(menu: Menu.main);
                  gameRef.resumeEngine();
                },
                child: Text(
                  'Play',
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
