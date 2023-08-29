import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game/utils/angles.dart';
import 'dart:math' as math;
import '../constants/constants.dart';
import '../fruit_collecting_game.dart';
import 'basket_component.dart';

class ExtraTimeComponent extends SpriteComponent
    with HasGameRef<FruitsCollectorGame>, CollisionCallbacks {
  final double _clockHeight = 80.0;
  late Vector2 _velocity;
  double speed = 150;
  final double degree = math.pi / 180;

  final Vector2 startPosition;

  ExtraTimeComponent({required this.startPosition});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Constants.extraTime);

    position = startPosition;

    final double vx = math.cos(Angles.getAngle() * degree) * speed;
    final double vy = math.sin(Angles.getAngle() * degree) * speed;

    _velocity = Vector2(vx, vy);
    width = _clockHeight * 0.8;
    height = _clockHeight;
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

    if (other is BasketComponent) {
      //shibin
      removeFromParent();
      gameRef.remainingTime += 6;
    }
  }
}
