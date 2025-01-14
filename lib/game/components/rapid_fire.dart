import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter/game/actors/player.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

class RapidFire extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  static const double _velocity = 200;
  static const int _rapidFireDuration = 25;
  static const double _bulletPeriod = 0.1;

  RapidFire({super.position}) : super(size: Vector2.all(45));

  @override
  FutureOr<void> onLoad() async {
    _addAnimation();
    _addHitBox();
    debugMode = true;
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
    if (other is Player) {
      other.updateBulletPeriod(_bulletPeriod);
      removeFromParent();
      Future.delayed(const Duration(seconds: _rapidFireDuration),
          () => other.resetBulletPeriod());
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  void _addAnimation() async {
    animation = await game.loadSpriteAnimation(
      'rapid-fire-power-up.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: .2,
        textureSize: Vector2(16, 16),
      ),
    );
  }

  void _addHitBox() {
    add(
      RectangleHitbox(collisionType: CollisionType.passive),
    );
  }

  void _updatePosition(double dt) {
    position.y += dt * _velocity;
  }

  void _removeWhenOutOfBound() {
    if (position.y > game.size.y) {
      removeFromParent();
    }
  }
}
