import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_shooter/game/overlays/hud.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(
    GameWidget<SpaceShooterGame>.controlled(
      gameFactory: SpaceShooterGame.new,
      overlayBuilderMap: {
        'Hud': (_, game) => Hud(game: game),
      },
    ),
  );
}
