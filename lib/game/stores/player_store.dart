import 'package:mobx/mobx.dart';

part 'player_store.g.dart';

class PlayerStore = _PlayerStore with _$PlayerStore;

abstract class _PlayerStore with Store {
  @observable
  int health = 0;

  @observable
  int maxHealth = 3;

  @observable
  int score = 0;

  _PlayerStore() {
    health = maxHealth;
  }

  @action
  void takeDamage(int damage) {
    if (!isDead()) {
      health = health - damage;
    }
  }

  void recoverHealth(int recovery) {
    if (!hasMaxHealth()) {
      health = health + recovery;
    }
  }

  bool isDead() {
    return health <= 0;
  }

  bool hasMaxHealth() {
    return health == maxHealth;
  }
}
