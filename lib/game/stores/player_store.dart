import 'package:mobx/mobx.dart';

part 'player_store.g.dart';

class PlayerStore = _PlayerStore with _$PlayerStore;

abstract class _PlayerStore with Store {
  @observable
  int health = 0;

  @action
  void takeDamage(int damage) {
    health = health - damage;
  }

  bool isDead() {
    return health <= 0;
  }
}
