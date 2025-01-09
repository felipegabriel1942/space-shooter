import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter/game/components/bullet.dart';
import 'package:space_shooter/game/components/enemy_bullet.dart';
import 'package:space_shooter/game/components/explosive.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  late final SpawnComponent _bulletSpawner;

  Enemy({
    super.position,
  }) : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
        );

  static const enemySize = 50.0;

  final double _velocity = 250;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

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
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * _velocity;

    if (position.y > game.size.y) {
      _bulletSpawner.removeFromParent();
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
      _bulletSpawner.removeFromParent();
      game.add(Explosion(position: position));
    }
  }
}
