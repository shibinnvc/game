import 'package:flutter/material.dart';
import 'screens/game_play.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.openHiveBox(boxName: 'settings');

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePlay(),
    ),
  );
}
