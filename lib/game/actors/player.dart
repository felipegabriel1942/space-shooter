import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:space_shooter/game/components/bullet.dart';
import 'package:space_shooter/game/components/enemy_bullet.dart';
import 'package:space_shooter/game/components/explosive.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

enum PlayerDirection {
  none,
  left,
  right,
  up,
  down,
  upLeft,
  upRight,
  downLeft,
  downRight,
}

enum PlayerAction { none, shooting }

class Player extends SpriteAnimationComponent
    with
        HasGameReference<SpaceShooterGame>,
        CollisionCallbacks,
        KeyboardHandler,
        TapCallbacks {
  late final SpawnComponent _bulletSpawner;
  PlayerDirection playerDirection = PlayerDirection.none;
  PlayerAction playerAction = PlayerAction.none;
  final double moveSpeed = 300;
  Vector2 velocity = Vector2.zero();

  Player()
      : super(
          size: Vector2.all(75),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await _loadPlayerAnimation();
    _addBulletSpawner();
    _addHitBox();
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is EnemyBullet) {
      stopShooting();
      removeFromParent();
      other.removeFromParent();
      _bulletSpawner.removeFromParent();
      game.add(Explosion(position: position));
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _updatePlayerDirection(keysPressed);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    _movePlayer(dt);
    super.update(dt);
  }

  void _movePlayer(double dt) {
    double dirX = 0.0;
    double dirY = 0.0;

    switch (playerDirection) {
      case PlayerDirection.left:
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        dirX += moveSpeed;
        break;
      case PlayerDirection.down:
        dirY += moveSpeed;
        break;
      case PlayerDirection.up:
        dirY -= moveSpeed;
        break;
      case PlayerDirection.upLeft:
        dirY -= moveSpeed;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.upRight:
        dirY -= moveSpeed;
        dirX += moveSpeed;
        break;
      case PlayerDirection.downLeft:
        dirY += moveSpeed;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.downRight:
        dirY += moveSpeed;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        break;
      default:
    }

    velocity = Vector2(dirX, dirY);
    position += velocity * dt;
  }

  void _updatePlayerDirection(Set<LogicalKeyboardKey> keysPressed) {
    final directionMap = {
      LogicalKeyboardKey.keyA: PlayerDirection.left,
      LogicalKeyboardKey.arrowLeft: PlayerDirection.left,
      LogicalKeyboardKey.keyD: PlayerDirection.right,
      LogicalKeyboardKey.arrowRight: PlayerDirection.right,
      LogicalKeyboardKey.keyW: PlayerDirection.up,
      LogicalKeyboardKey.arrowUp: PlayerDirection.up,
      LogicalKeyboardKey.keyS: PlayerDirection.down,
      LogicalKeyboardKey.arrowDown: PlayerDirection.down,
    };

    final activeDirections = <PlayerDirection>{};

    for (var key in keysPressed) {
      if (directionMap.containsKey(key)) {
        activeDirections.add(directionMap[key]!);
      }
    }

    final directionCombinations = {
      {PlayerDirection.up, PlayerDirection.left}: PlayerDirection.upLeft,
      {PlayerDirection.up, PlayerDirection.right}: PlayerDirection.upRight,
      {PlayerDirection.down, PlayerDirection.left}: PlayerDirection.downLeft,
      {PlayerDirection.down, PlayerDirection.right}: PlayerDirection.downRight,
      {PlayerDirection.up}: PlayerDirection.up,
      {PlayerDirection.down}: PlayerDirection.down,
      {PlayerDirection.left}: PlayerDirection.left,
      {PlayerDirection.right}: PlayerDirection.right
    };

    playerDirection = PlayerDirection.none;

    for (var combination in directionCombinations.keys) {
      if (activeDirections.containsAll(combination)) {
        playerDirection = directionCombinations[combination]!;
        break;
      }
    }
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

  void move(Vector2 delta) {
    position.add(delta);
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
}
