import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';
import 'package:space_shooter/game/components/bullet.dart';
import 'package:space_shooter/game/components/enemy_bullet.dart';
import 'package:space_shooter/game/components/explosive.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

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
  int health = 3;
  Vector2 velocity = Vector2.zero();
  double horizontalMovement = 0;
  double verticalMovement = 0;

  Player()
      : super(
          size: Vector2(50, 75),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    _addBulletSpawner();
    await _loadPlayerAnimation();

    _addHitBox();
    debugMode = true;
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is EnemyBullet && !hitByEnemy) {
      --health;
      hitByEnemy = true;

      other.removeFromParent();

      if (isDead()) {
        stopShooting();
        removeFromParent();
        _bulletSpawner.removeFromParent();
        game.add(Explosion(position: position));
      } else {
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
    position.x += velocity.x * dt;

    velocity.y = verticalMovement * moveSpeed;
    position.y += velocity.y * dt;
  }

  bool isDead() {
    return health == 0;
  }

  Future<void> _loadPlayerAnimation() async {
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
      period: .5,
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
}
