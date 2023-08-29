import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:game/components/apple_fruit_component.dart';
import 'components/background_component.dart';
import 'components/boost_component.dart';
import 'components/extra_time_component.dart';
import 'components/lemon_fruits_component.dart';
import 'components/bomb_component.dart';
import 'components/basket_component.dart';
import 'constants/constants.dart';
import 'joystick/joystick.dart';
import 'screens/game_play.dart';
import 'dart:math';

class FruitsCollectorGame extends FlameGame
    with DragCallbacks, HasCollisionDetection {
  final BasketComponent _characterComponent =
      BasketComponent(joystick: joystick);
  final BackgroundComponent _backgroundComponent = BackgroundComponent();
  final LemonFruitComponent _lemonComponent = LemonFruitComponent();
  final AppleFruitComponent _appleFruitComponent = AppleFruitComponent();
  final ExtraTimeComponent _extraTimeComponent = ExtraTimeComponent(
    startPosition: Vector2(200, 200),
  );
  int score = 0;
  int remainingTime = Constants.gameTimeLimit;
  int _extraTimeRemainingTime = Constants.extraTimeLimit;

  /// Timer for game countdown.
  late Timer gameTimer;
  late Timer extraTimer;

  late TextComponent _scoreText;
  late TextComponent _timerText;
  late TextComponent extraTimerText;

  static int _extraTimeAppearance = _getRandomInt(
    min: 10,
    max: Constants.gameTimeLimit,
  );

  static int _boostTimeAppearance = _getRandomInt(
    min: 10,
    max: Constants.gameTimeLimit,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    pauseEngine();
    gameTimer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (remainingTime == 0) {
          pauseEngine();
          addMenu(menu: Menu.gameOver);
        } else if (remainingTime == _extraTimeAppearance) {
          add(_extraTimeComponent);
        } else if (remainingTime == _boostTimeAppearance) {
          add(BoostComponent());
        } else if (remainingTime % 3 == 0) {
          add(LemonFruitComponent());
        } else if (remainingTime % 5 == 0) {
          add(AppleFruitComponent());
        }
        remainingTime -= 1;
      },
    );

    extraTimer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (_extraTimeRemainingTime == 0) {
          _characterComponent.unflameBasket();
          extraTimerText.removeFromParent();
        } else {
          _extraTimeRemainingTime -= 1;
        }
      },
    );

    // Preload audio files.
    await FlameAudio.audioCache.loadAll(
      [
        Constants.freezeSound,
        Constants.itemPickSound,
        Constants.boostSound,
      ],
    );

    add(_backgroundComponent);
    add(_lemonComponent);
    add(_appleFruitComponent);
    add(BombComponent(startPosition: Vector2(200, 200)));
    add(BombComponent(startPosition: Vector2(size.x - 200, size.y - 200)));
    add(_characterComponent);
    add(joystick);
    add(ScreenHitbox());

    _scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(40, 50),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: 25,
        ),
      ),
    );
    add(_scoreText);

    _timerText = TextComponent(
      text: 'Time: $remainingTime',
      position: Vector2(size.x - 40, 50),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: 25,
        ),
      ),
    );

    add(_timerText);

    extraTimerText = TextComponent(
      text: 'Extra Time: $_extraTimeRemainingTime',
      position: Vector2(size.x - 40, size.y - 100),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.black.color,
          fontSize: 25,
        ),
      ),
    );

    gameTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    gameTimer.update(dt);

    if (_characterComponent.isFlamed) {
      extraTimer.update(dt);
      extraTimerText.text = 'Flame Time: $_extraTimeRemainingTime';
    }

    _scoreText.text = 'Score: $score';
    _timerText.text = 'Time: $remainingTime secs';
  }

  void reset() {
    score = 0;

    remainingTime = Constants.gameTimeLimit;
    _extraTimeRemainingTime = Constants.extraTimeLimit;
    _extraTimeAppearance = _getRandomInt(
      min: 10,
      max: remainingTime,
    );
    _boostTimeAppearance = _getRandomInt(
      min: 10,
      max: remainingTime,
    );
    _extraTimeComponent.removeFromParent();
    extraTimerText.removeFromParent();
  }

  void addMenu({
    required Menu menu,
  }) {
    overlays.add(menu.name);
  }

  void removeMenu({
    required Menu menu,
  }) {
    overlays.remove(menu.name);
  }

  static int _getRandomInt({
    required int min,
    required int max,
  }) {
    Random rng = Random();
    return rng.nextInt(max - min) + min;
  }
}
