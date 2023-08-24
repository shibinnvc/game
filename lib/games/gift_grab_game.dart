import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../components/background_component.dart';
import '../components/boost_component.dart';
import '../components/extra_time_component.dart';
import '../components/lemon_fruits_component.dart';
import '../components/ice_component.dart';
import '../components/basket_component.dart';
import '../constants/constants.dart';
import '../inputs/joystick.dart';
import '../screens/game_play.dart';
import 'dart:math';

class FruitsCollectorGame extends FlameGame
    with DragCallbacks, HasCollisionDetection {
  /// The character who collects the gifts.
  final BasketComponent _characterComponent =
      BasketComponent(joystick: joystick);

  /// Background of snow landscape.
  final BackgroundComponent _backgroundComponent = BackgroundComponent();

  /// The first gift to collect.
  final LemonFruitComponent _lemonComponent = LemonFruitComponent();

  /// Flame powerup.
  final ExtraTimeComponent _extraTimeComponent = ExtraTimeComponent(
    startPosition: Vector2(200, 200),
  );

  // Number of fruits collected.
  int score = 0;

  // Total seconds for each game.
  static int _remainingTime = Constants.gameTimeLimit;

  int _extraTimeRemainingTime = Constants.extraTimeLimit;

  /// Timer for game countdown.
  late Timer gameTimer;

  late Timer flameTimer;

  /// Text UI component for score.
  late TextComponent _scoreText;

  /// Text UI component for timer.
  late TextComponent _timerText;

  /// Text UI component for flame counter.
  late TextComponent flameTimerText;

  /// Time when the flame appears.
  static int _extraTimeAppearance = _getRandomInt(
    min: 10,
    max: _remainingTime,
  );

  /// Time when the flame appears.
  static int _boostTimeAppearance = _getRandomInt(
    min: 10,
    max: _remainingTime,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    pauseEngine();

    // Configure countdown timer.
    gameTimer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (_remainingTime == 0) {
          // Pause the game.
          pauseEngine();
          // Display game over menu.
          addMenu(menu: Menu.gameOver);
        } else if (_remainingTime == _extraTimeAppearance) {
          // Display the flame powerup.
          add(_extraTimeComponent);
        } else if (_remainingTime == _boostTimeAppearance) {
          // Display the cookie powerup.
          add(BoostComponent());
        }

        // Decrement time by one second.
        _remainingTime -= 1;
      },
    );

    flameTimer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (_extraTimeRemainingTime == 0) {
          _characterComponent.unflameSanta();
          flameTimerText.removeFromParent();
        } else {
          _extraTimeRemainingTime -= 1;
        }
      },
    );

    // Preload audio files.
    await FlameAudio.audioCache.loadAll(
      [
        Constants.freezeSound,
        Constants.itemGrabSound,
        Constants.flameSound,
      ],
    );

    // Add background component here.
    add(_backgroundComponent);

    // Add initial gift.
    add(_lemonComponent);

    // Add ice blocks.
    add(BombComponent(startPosition: Vector2(200, 200)));
    add(BombComponent(startPosition: Vector2(size.x - 200, size.y - 200)));

    // Add character.
    add(_characterComponent);

    // Add joystick.
    add(joystick);

    // Add ScreenHitBox for boundries for bombs.
    add(ScreenHitbox());

    // Configure TextComponent
    _scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(40, 50),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: Constants.isTablet ? 50 : 25,
        ),
      ),
    );

    // Add Score TextComponent.
    add(_scoreText);

    // Configure TextComponent
    _timerText = TextComponent(
      text: 'Time: $_remainingTime',
      position: Vector2(size.x - 40, 50),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: Constants.isTablet ? 50 : 25,
        ),
      ),
    );

    // Add Score TextComponent.
    add(_timerText);

    // Configure TextComponent
    flameTimerText = TextComponent(
      text: 'Flame Time: $_extraTimeRemainingTime',
      position: Vector2(size.x - 40, size.y - 100),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.black.color,
          fontSize: Constants.isTablet ? 50 : 25,
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
      flameTimer.update(dt);
      flameTimerText.text = 'Flame Time: $_extraTimeRemainingTime';
    }

    _scoreText.text = 'Score: $score';
    _timerText.text = 'Time: $_remainingTime secs';
  }

  /// Reset score and remaining time to default values.
  void reset() {
    // Scores
    score = 0;

    // Timers
    _remainingTime = Constants.gameTimeLimit;
    _extraTimeRemainingTime = Constants.extraTimeLimit;

    // Time Appearences
    _extraTimeAppearance = _getRandomInt(
      min: 10,
      max: _remainingTime,
    );
    _boostTimeAppearance = _getRandomInt(
      min: 10,
      max: _remainingTime,
    );

    // Sprites
    _extraTimeComponent.removeFromParent();

    // Texts
    flameTimerText.removeFromParent();
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
