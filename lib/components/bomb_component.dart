import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/utils/angles.dart';
import 'dart:math' as math;
import '../constants/constants.dart';
import '../fruit_collecting_game.dart';

class BombComponent extends SpriteComponent
    with HasGameRef<FruitsCollectorGame>, CollisionCallbacks {
  final Vector2 startPosition;
  BombComponent({required this.startPosition});
  final double _bombHeight = 100.0;

  // Speed and direction of bomb.
  late Vector2 _velocity;
  double speed = 150;

  // Angle of the bomb on bounce back.
  final double degree = math.pi / 180;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Constants.bomb);

    position = startPosition;

    final double spawnAngle = Angles.getAngle();

    final double vx = math.cos(spawnAngle * degree) * speed;
    final double vy = math.sin(spawnAngle * degree) * speed;

    _velocity = Vector2(vx, vy);
    width = _bombHeight;
    height = _bombHeight;
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
      //screenSide
      final Vector2 collisionPoint = intersectionPoints.first;
      // Collision (Left, Right, Top, Bottom)
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
  }
}
