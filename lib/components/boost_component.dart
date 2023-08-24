import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:math' as math;

import '../constants/constants.dart';
import '../games/gift_grab_game.dart';
import 'basket_component.dart';

class BoostComponent extends SpriteComponent
    with HasGameRef<FruitsCollectorGame>, CollisionCallbacks {
  /// Height of the sprite.
  final double _spriteHeight = Constants.isTablet ? 160.0 : 80.0;

  /// Speed and direction of gift.
  late Vector2 _velocity;

  /// Speed of the cookies.
  double speed = Constants.isTablet ? 600 : 300;

  /// Angle or the gift on bounce back.
  final double degree = math.pi / 180;

  BoostComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Constants.ligthingSprite);

    position = Vector2(200, 200);

    final double spawnAngle = _getSpawnAngle();

    final double vx = math.cos(spawnAngle * degree) * speed;
    final double vy = math.sin(spawnAngle * degree) * speed;

    _velocity = Vector2(vx, vy);

    // Set dimensions of santa sprite.
    width = _spriteHeight;
    height = _spriteHeight;

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

      // Left Side Collision
      if (collisionPoint.x == 0) {
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      // Right Side Collision
      if (collisionPoint.x == gameRef.size.x) {
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      // Top Side Collision
      if (collisionPoint.y == 0) {
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
      // Bottom Side Collision
      if (collisionPoint.y == gameRef.size.y) {
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
    }

    if (other is BasketComponent) {
      removeFromParent();
    }
  }

  double _getSpawnAngle() {
    final random = math.Random().nextDouble();
    final spawnAngle = lerpDouble(0, 360, random)!;

    return spawnAngle;
  }
}
