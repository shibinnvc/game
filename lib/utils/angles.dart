import 'dart:math' as math;
import 'dart:ui';

class Angles {
  //here we change the angle of component when it hit the wall
  static double getAngle() {
    final random = math.Random().nextDouble();
    //This will return a random number between 0 to 360
    final spawnAngle = lerpDouble(0, 360, random)!;
    return spawnAngle;
  }
}
