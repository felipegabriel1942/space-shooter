import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:space_shooter/game/components/bullet.dart';
import 'package:space_shooter/game/components/enemy_bullet.dart';
import 'package:space_shooter/game/components/explosive.dart';
import 'package:space_shooter/game/space_shooter_game.dart';
import 'package:space_shooter/game/stores/player_store.dart';

enum PlayerAction { none, shooting }

class Player extends SpriteAnimationComponent
    with
        HasGameReference<SpaceShooterGame>,
        CollisionCallbacks,
        KeyboardHandler {
  late final SpawnComponent _bulletSpawner;
  PlayerAction playerAction = PlayerAction.none;
  final double moveSpeed = 400;
  bool hitByEnemy = false;
  Vector2 velocity = Vector2.zero();
  double horizontalMovement = 0;
  double verticalMovement = 0;
  PlayerStore playerStore = PlayerStore();
  final double bulletPeriod = 0.4;

  Player()
      : super(
          size: Vector2(50, 75),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
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
    _updatePlayerMovement(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    _updatePlayerPosition(dt);
    super.update(dt);
  }

  void _updatePlayerPosition(double dt) {
    velocity.x = horizontalMovement * moveSpeed;

    if (_inBoundariesX(dt)) {
      position.x += velocity.x * dt;
    }

    velocity.y = verticalMovement * moveSpeed;

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

  void _updatePlayerMovement(Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;
    verticalMovement += isUpKeyPressed ? -1 : 0;
    verticalMovement += isDownKeyPressed ? 1 : 0;
  }

  void updateBulletPeriod(double newPeriod) {
    _bulletSpawner.period = newPeriod;
  }

  void resetBulletPeriod() {
    _bulletSpawner.period = bulletPeriod;
  }
}
