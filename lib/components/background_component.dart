import 'package:flame/components.dart';
import '../constants/globals.dart';
import '../games/gift_grab_game.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameRef<GiftGrabGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.backgroundSprite);
    size = gameRef.size;
  }
}
