import 'package:flutter/material.dart';
import '../../data/constants/globals.dart';
import '../../data/constants/screens.dart';
import '../games/gift_grab_game.dart';
import '../widgets/screen_background_widget.dart';

class MainMenu extends StatelessWidget {
  final GiftGrabGame gameRef;
  const MainMenu({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

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
                'Gift Grab',
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
                  gameRef.removeMenu(menu: Screens.main);
                  gameRef.resumeEngine();
                },
                child: Text(
                  'Play',
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
