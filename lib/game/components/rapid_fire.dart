import 'dart:async';

import 'package:flame/components.dart';
import 'package:space_shooter/game/actors/player.dart';
import 'package:space_shooter/game/components/power_up.dart';

class RapidFire extends PowerUp {
  static const int _rapidFireDuration = 25;
  static const double _bulletPeriod = 0.1;
  static const String _spriteSheet = 'rapid-fire-power-up.png';

  RapidFire({super.position})
      : super(
          velocity: 150,
          size: Vector2.all(45),
        );

  @override
  void handleCollision(PositionComponent other) {
    if (other is Player) {
      other.updateBulletPeriod(_bulletPeriod);
      removeFromParent();
      Future.delayed(const Duration(seconds: _rapidFireDuration),
          () => other.resetBulletPeriod());
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
