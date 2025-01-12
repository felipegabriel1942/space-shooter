import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:space_shooter/game/actors/enemy.dart';
import 'package:space_shooter/game/actors/player.dart';

class SpaceShooterGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );

    add(parallax);

    player = Player();

    add(player);

    // Spawn enemies on screen
    add(
      SpawnComponent(
        period: 1,
        factory: (index) {
          return Enemy();
        },
        area: Rectangle.fromLTWH(0, 0, size.x - 300, -Enemy.enemySize),
      ),
    );

    overlays.add('Hud');
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
    super.onPanStart(info);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
    super.onPanEnd(info);
  }
}
