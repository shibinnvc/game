import 'package:flame/components.dart';
import '../constants/constants.dart';
import '../fruit_collecting_game.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameRef<FruitsCollectorGame> {
  @override
  Future<void> onLoad() async {
    //This function will load the background image.
    await super.onLoad();
    //give the background image here.
    sprite = await gameRef.loadSprite(Constants.background);
    //we can handle background image size here.
    size = gameRef.size;
  }
}
