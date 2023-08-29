import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:game/utils/angles.dart';
import '../constants/constants.dart';
import '../fruit_collecting_game.dart';
import 'basket_component.dart';
import 'dart:math' as math;

class AppleFruitComponent extends SpriteComponent
    with HasGameRef<FruitsCollectorGame>, CollisionCallbacks {
  /// Height of the apple.
  final double _appleHeight = 60.0;
  late Vector2 _velocity;
  double speed = 400;
  final double degree = math.pi / 180;

  AppleFruitComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Constants.apple);

    position = Vector2(200, 200);

    final double vx = math.cos(Angles.getAngle() * degree) * speed;
    final double vy = math.sin(Angles.getAngle() * degree) * speed;

    _velocity = Vector2(vx, vy);

    // Set dimensions of apple sprite.
    width = _appleHeight;
    height = _appleHeight;

    anchor = Anchor.center;
    add(CircleHitbox()..radius = 1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += _velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {
      final Vector2 collisionPoint = intersectionPoints.first;
      //Side Collisions(Left, Right,Top,Bottom)
      if (collisionPoint.x == 0) {
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }

      if (collisionPoint.x == gameRef.size.x) {
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }

      if (collisionPoint.y == 0) {
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }

      if (collisionPoint.y == gameRef.size.y) {
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
    }
    if (other is BasketComponent) {
      FlameAudio.play(Constants.itemPickSound);
      removeFromParent();
      gameRef.score += 2;
    }
  }
}
