import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../constants/constants.dart';
import '../fruit_collecting_game.dart';
import 'boost_component.dart';
import 'extra_time_component.dart';
import 'bomb_component.dart';

enum MovementState {
  idle,
  frozen,
}

class BasketComponent extends SpriteGroupComponent<MovementState>
    with HasGameRef<FruitsCollectorGame>, CollisionCallbacks {
  final double _basketHeight = 100;
  static double _speed = 250.0;

  /// Joystick.
  final JoystickComponent joystick;

  /// Screen boundries.
  late double _rightBound;
  late double _leftBound;
  late double _upBound;
  late double _downBound;

  bool isFrozen = false;

  bool isFlamed = false;
  final Timer _frozenCountdown = Timer(4);
  final Timer _boostCountdown = Timer(4);

  BasketComponent({required this.joystick});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final basketIdle = await gameRef.loadSprite(Constants.basketIdle);
    final Sprite basketFrozen =
        await gameRef.loadSprite(Constants.basketFrozen);
    sprites = {
      MovementState.idle: basketIdle,
      MovementState.frozen: basketFrozen,
    };

    // Set  screen boundrys.
    _rightBound = gameRef.size.x - 45;
    _leftBound = 0 + 45;
    _upBound = 0 + 55;
    _downBound = gameRef.size.y - 55;

    // Set position of component to center of screen.
    position = gameRef.size;
    // Set dimensions of basket.
    width = _basketHeight * 1.42;
    height = _basketHeight;

    // Set anchor of component.
    anchor = Anchor.bottomCenter;

    // Default current state to idle.
    current = MovementState.idle;

    add(CircleHitbox()..radius = 1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // If Basket is not frozen, update position.
    if (!isFrozen) {
      // If joystick is idle, set state to idle.
      if (joystick.direction == JoystickDirection.idle) {
        current = MovementState.idle;
        return;
      }

      if (x >= _rightBound) {
        x = _rightBound - 1;
      }
      if (x <= _leftBound) {
        x = _leftBound + 1;
      }
      if (y >= _downBound) {
        y = _downBound - 1;
      }

      if (y <= _upBound) {
        y = _upBound + 1;
      }

      // Determines if the component is moving left currently.
      bool moveLeft = joystick.relativeDelta[0] < 0;

      if (moveLeft) {
        current = MovementState.idle;
      } else {
        current = MovementState.idle;
      }

      _boostCountdown.update(dt);
      if (_boostCountdown.finished) {
        _resetBasketSpeed();
      }

      // Update position here.
      position.add(joystick.relativeDelta * _speed * dt);
    } else {
      _frozenCountdown.update(dt);
      if (_frozenCountdown.finished) {
        _unfreezeBasket();
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BombComponent) {
      if (!isFlamed) {
        _freezeBasket();
      }
    }
    if (other is ExtraTimeComponent) {
      flameBasket();
    }

    if (other is BoostComponent) {
      _increaseBasketSpeed();
    }
  }

  void flameBasket() {
    // Check if already frozen.
    if (!isFrozen) {
      isFlamed = true;
      FlameAudio.play(Constants.boostSound);
      // gameRef.add(gameRef.flameTimerText);
      // gameRef.flameTimer.start();
    }
  }

  void unflameBasket() {
    isFlamed = false;
  }

  void _increaseBasketSpeed() {
    FlameAudio.play(Constants.itemPickSound);
    _speed *= 2;
    // Start the speed countdown.
    _boostCountdown.start();
  }

  void _resetBasketSpeed() {
    _speed = 250;
  }

  void _freezeBasket() {
    if (!isFrozen) {
      isFrozen = true;
      FlameAudio.play(Constants.freezeSound);
      current = MovementState.frozen;
      _frozenCountdown.start();
    }
  }

  void _unfreezeBasket() {
    isFrozen = false;
    current = MovementState.idle;
  }
}
