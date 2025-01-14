import 'dart:async';

import 'package:flame/components.dart';
import 'package:space_shooter/game/actors/player.dart';
import 'package:space_shooter/game/components/power_up.dart';

class Health extends PowerUp {
  static const String _spriteSheet = 'health-power-up.png';

  Health({super.position})
      : super(
          velocity: 150,
          size: Vector2.all(45),
        );

  @override
  void handleCollision(PositionComponent other) {
    if (other is Player) {
      other.playerStore.recoverHealth(1);
      removeFromParent();
    }
  }

  @override
  Future<void> loadAnimation() async {
    animation = await game.loadSpriteAnimation(
      _spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: .2,
        textureSize: Vector2(16, 16),
      ),
    );
  }
}
