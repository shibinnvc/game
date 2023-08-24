class Constants {
  Constants._();

  /// Audio
  static const String freezeSound = 'freeze-sound.wav';
  static const String itemGrabSound = 'item-grab-sound.wav';
  static const String flameSound = 'flame-sound.wav';

  /// Images
  static const String characterIdle = 'santa-idle.png';
  static const String characterFrozen = 'santa-frozen.png';
  static const String characterSlideLeftSprite = 'santa-slide-left.png';
  static const String santaSlideRightSprite = 'santa-slide-right.png';
  static const String backgroundSprite = 'background-sprite.jpg';
  static const String giftSprite = 'gift-sprite.png';
  static const String iceSprite = 'ice-sprite.png';
  static const String ligthingSprite = 'ligthing.png';
  static const String extraTimeSprite = 'time.png';

  static late bool isTablet;

  static const int gameTimeLimit = 30;
  static const int frozenTimeLimit = 3;
  static const int extraTimeLimit = 6;
  static const int lightingTimeLimit = 6;
}
