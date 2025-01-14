import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:space_shooter/game/actors/player.dart';

class PlayerMovementService {
  final Player player;
  final double moveSpeed;

  PlayerMovementService({required this.player, required this.moveSpeed});

  void updatePlayerMovement(Set<LogicalKeyboardKey> keysPressed) {
    double horizontalMovement = 0;
    double verticalMovement = 0;

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

    player.velocity = Vector2(horizontalMovement, verticalMovement) * moveSpeed;
  }
}
