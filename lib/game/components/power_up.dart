import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

abstract class PowerUp extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  final double velocity;

  PowerUp({
    required this.velocity,
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() async {
    await _addAnimation();
    _addHitBox();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updatePosition(dt);
    _removeWhenOutOfBound();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    handleCollision(other);
    super.onCollisionStart(intersectionPoints, other);
  }

  Future<void> _addAnimation() async {
    await loadAnimation();
  }

  void _addHitBox() {
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  void _updatePosition(double dt) {
    position.y += dt * velocity;
  }

  void _removeWhenOutOfBound() {
    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  Future<void> loadAnimation();

  void handleCollision(PositionComponent other);
}
