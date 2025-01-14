import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter/game/actors/player.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

class RapidFire extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  RapidFire({super.position}) : super(size: Vector2.all(45));

  @override
  FutureOr<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'rapid-fire-power-up.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: .2,
        textureSize: Vector2(16, 16),
      ),
    );

    add(
      RectangleHitbox(collisionType: CollisionType.passive),
    );

    debugMode = true;

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      other.updateBulletPeriod(0.1);
      removeFromParent();
      Future.delayed(
          const Duration(seconds: 25), () => other.resetBulletPeriod());
    }

    super.onCollisionStart(intersectionPoints, other);
  }
}
