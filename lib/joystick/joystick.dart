import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

final JoystickComponent joystick = JoystickComponent(
  knob: CircleComponent(
    radius: 30,
    paint: BasicPalette.white.paint(),
  ),
  background: CircleComponent(
    radius: 50,
    paint: BasicPalette.white.withAlpha(100).paint(),
  ),
  margin: const EdgeInsets.only(left: 40, bottom: 40),
);
