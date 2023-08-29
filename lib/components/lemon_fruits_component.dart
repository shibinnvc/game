import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:game/utils/angles.dart';
import '../constants/constants.dart';
import '../fruit_collecting_game.dart';
import 'basket_component.dart';
import 'dart:math' as math;

class LemonFruitComponent extends SpriteComponent
    with HasGameRef<FruitsCollectorGame>, CollisionCallbacks {
  LemonFruitComponent();
  final double _lemonHeight = 100.0;
  late Vector2 _velocity;
  double speed = 300;

  /// Angle or the lemon on bounce back.
  final double degree = math.pi / 180;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Constants.lemon);
    position =
        Vector2(Random().nextInt(gameRef.size.x.toInt()).toDouble(), 200);
    final double spawnAngle = Angles.getAngle();

    final double vx = math.cos(spawnAngle * degree) * speed;
    final double vy = math.sin(spawnAngle * degree) * speed;

    _velocity = Vector2(vx, vy);
    width = _lemonHeight;
    height = _lemonHeight;

    // Set anchor of component.
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
      // Collision(Left, Right, Top, Bottom)
      // Left
      if (collisionPoint.x == 0) {
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      // Right
      if (collisionPoint.x == gameRef.size.x) {
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      // Top
      if (collisionPoint.y == 0) {
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
      // Bottom
      if (collisionPoint.y == gameRef.size.y) {
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
    }
    if (other is BasketComponent) {
      FlameAudio.play(Constants.itemPickSound);
      removeFromParent();
      gameRef.score += 1;
    }
  }
}
