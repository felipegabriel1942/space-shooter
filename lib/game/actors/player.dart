import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:space_shooter/game/components/bullet.dart';
import 'package:space_shooter/game/components/enemy_bullet.dart';
import 'package:space_shooter/game/components/explosive.dart';
import 'package:space_shooter/game/services/player_movement_service.dart';
import 'package:space_shooter/game/space_shooter_game.dart';
import 'package:space_shooter/game/stores/player_store.dart';

enum PlayerAction { none, shooting }

class Player extends SpriteAnimationComponent
    with
        HasGameReference<SpaceShooterGame>,
        CollisionCallbacks,
        KeyboardHandler {
  late final SpawnComponent _bulletSpawner;
  late final PlayerMovementService _movementService;
  late final PlayerStore playerStore;

  PlayerAction playerAction = PlayerAction.none;
  bool hitByEnemy = false;
  Vector2 velocity = Vector2.zero();
  final double bulletPeriod = 0.4;

  Player()
      : super(
          size: Vector2(50, 75),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    _movementService = PlayerMovementService(player: this, moveSpeed: 400);
    playerStore = PlayerStore();
    _loadPlayerAnimation();
    _addBulletSpawner();
    _addHitBox();
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is EnemyBullet && !hitByEnemy) {
      playerStore.takeDamage(1);
      hitByEnemy = true;

      other.removeFromParent();

      if (playerStore.isDead()) {
        _handleDeath();
      } else {
        _handleHit();
      }
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _movementService.updatePlayerMovement(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    _updatePlayerPosition(dt);
    super.update(dt);
  }

  void _updatePlayerPosition(double dt) {
    if (_inBoundariesX(dt)) {
      position.x += velocity.x * dt;
    }

    if (_inBoundariesY(dt)) {
      position.y += velocity.y * dt;
    }
  }

  bool _inBoundariesX(double dt) {
    return velocity.x * dt + position.x > size.x / 2 &&
        velocity.x * dt + position.x < game.size.x - size.x / 2;
  }

  bool _inBoundariesY(double dt) {
    return velocity.y * dt + position.y > size.y / 2 &&
        velocity.y * dt + position.y < game.size.y - size.y / 2;
  }

  void _handleDeath() {
    stopShooting();
    removeFromParent();
    _removeBulletSpawner();
    game.add(Explosion(position: position));
  }

  void _handleHit() {
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 6,
        ),
      )..onComplete = () {
          hitByEnemy = false;
        },
    );
  }

  void _loadPlayerAnimation() async {
    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(32, 48),
      ),
    );

    position = game.size / 2;
  }

  void _addBulletSpawner() {
    _bulletSpawner = SpawnComponent(
      period: bulletPeriod,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          position: position +
              Vector2(
                0,
                -height / 2,
              ),
        );
      },
      autoStart: false,
    );

    game.add(_bulletSpawner);
  }

  void _removeBulletSpawner() {
    _bulletSpawner.removeFromParent();
  }

  void _addHitBox() {
    add(
      RectangleHitbox(),
    );
  }

  void startShooting() {
    if (!_bulletSpawner.timer.isRunning()) {
      _bulletSpawner.timer.start();
    }
  }

  void stopShooting() {
    if (_bulletSpawner.timer.isRunning()) {
      _bulletSpawner.timer.stop();
    }
  }

  void updateBulletPeriod(double newPeriod) {
    _bulletSpawner.period = newPeriod;
  }

  void resetBulletPeriod() {
    _bulletSpawner.period = bulletPeriod;
  }
}
