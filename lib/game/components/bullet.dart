import 'package:space_shooter/game/components/base_bullet.dart';

class Bullet extends BaseBullet {
  Bullet({super.position})
      : super(
          velocity: -500,
          spritePath: 'red-bullet.png',
        );
}
