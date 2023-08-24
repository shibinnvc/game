import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
// import 'dart:math';

import '../constants/constants.dart';
import '../games/gift_grab_game.dart';
import 'basket_component.dart';
import 'dart:math' as math;

class LemonFruitComponent extends SpriteComponent
    with HasGameRef<FruitsCollectorGame>, CollisionCallbacks {
  /// Height of the sprite.
  final double _spriteHeight = Constants.isTablet ? 200.0 : 100.0;

  /// Speed and direction of gift.
  late Vector2 _velocity;

  /// Speed of the cookies.
  double speed = Constants.isTablet ? 600 : 300;

  /// Angle or the gift on bounce back.
  final double degree = math.pi / 180;
  // /// Used for generating random position of gift.
  // final Random _random = Random();

  LemonFruitComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Constants.giftSprite);

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

    //To know component hit
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
      print('here is the collision');
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
    // If collision comes from Santa...
    if (other is BasketComponent) {
      // Play gift grab sound.
      FlameAudio.play(Constants.itemGrabSound);

      // Remove the just collided gift.
      removeFromParent();

      // Update Santa's score by one.
      gameRef.score += 1;

      // Add a new gift to the field.
      gameRef.add(LemonFruitComponent());
    }
  }

  double _getSpawnAngle() {
    final random = math.Random().nextDouble();
    final spawnAngle = lerpDouble(0, 360, random)!;

    return spawnAngle;
  }

  // /// Create new position for the gift on random.
  // Vector2 _createRandomPosition() {
  //   final double x = _random.nextInt(gameRef.size.x.toInt()).toDouble();
  //   final double y = _random.nextInt(gameRef.size.y.toInt()).toDouble();

  //   return Vector2(x, y);
  // }
}
