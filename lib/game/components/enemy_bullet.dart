import 'package:space_shooter/game/components/base_bullet.dart';

class EnemyBullet extends BaseBullet {
  EnemyBullet({super.position})
      : super(
          spritePath: 'green-bullet.png',
          velocity: 500,
          shouldRotate: true,
        );
}
