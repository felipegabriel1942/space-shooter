import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

abstract class BaseBullet extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  final String spritePath;
  final double velocity;
  final bool shouldRotate;

  BaseBullet({
    required this.spritePath,
    required this.velocity,
    this.shouldRotate = false,
    super.position,
  }) : super(
          size: Vector2(10, 30),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      spritePath,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(8, 16),
      ),
    );

    if (shouldRotate) {
      angle = 3.1;
    }

    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * velocity;

    if (position.y > game.size.y || position.y < 0) {
      removeFromParent();
    }
  }
}
