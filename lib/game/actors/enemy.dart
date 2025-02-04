import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter/game/components/bullet.dart';
import 'package:space_shooter/game/components/enemy_bullet.dart';
import 'package:space_shooter/game/components/explosive.dart';
import 'package:space_shooter/game/components/health.dart';
import 'package:space_shooter/game/components/rapid_fire.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  static const enemySize = 40.0;
  final double _velocity = 200;
  static const _points = 100;

  late final SpawnComponent _bulletSpawner;

  Enemy({
    super.position,
  }) : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
        );

  @override
  FutureOr<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2.all(16),
      ),
    );

    _bulletSpawner = SpawnComponent(
      period: 1.5,
      selfPositioning: true,
      factory: (_) {
        return EnemyBullet(
          position: position + Vector2(0, height / 2),
        );
      },
      autoStart: true,
    );

    game.add(_bulletSpawner);

    add(
      RectangleHitbox(),
    );

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
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      other.removeFromParent();
      _bulletSpawner.removeFromParent();
      game.player.playerStore.score += _points;
      game.add(Explosion(position: position));
      _handlePowerUpDrop();
      removeFromParent();
    }
  }

  _handlePowerUpDrop() {
    if (checkChance(10) && !game.player.playerStore.hasMaxHealth()) {
      game.add(Health(position: position));
      return;
    }

    if (checkChance(5)) {
      game.add(RapidFire(position: position));
      return;
    }
  }

  bool checkChance(int chance) {
    final random = Random();

    final randomNumber = random.nextInt(100);

    return randomNumber < chance;
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
