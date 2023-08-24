import 'package:flame/components.dart';
import '../constants/constants.dart';
import '../games/gift_grab_game.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameRef<FruitsCollectorGame> {
  @override
  Future<void> onLoad() async {
    //This function will load the background image.
    await super.onLoad();
    //give the background image here.
    sprite = await gameRef.loadSprite(Constants.backgroundSprite);
    //we can handle background image size here.
    size = gameRef.size;
  }
}
