import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter/game/actors/player.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

class Health extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  Health({super.position}) : super(size: Vector2.all(45));

  @override
  FutureOr<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'health-power-up.png',
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
      other.playerStore.recoverHealth(1);
      removeFromParent();
    }

    super.onCollisionStart(intersectionPoints, other);
  }
}
