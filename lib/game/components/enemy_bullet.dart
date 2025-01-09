import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

class EnemyBullet extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  EnemyBullet({super.position})
      : super(
          size: Vector2(25, 50),
          anchor: Anchor.center,
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'green-bullet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(8, 16),
      ),
    );

    // rotate sprite
    angle += 3.1;

    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    var velocity = 500;

    position.y += dt * velocity;

    if (position.y < -height) {
      removeFromParent();
    }
  }
}
