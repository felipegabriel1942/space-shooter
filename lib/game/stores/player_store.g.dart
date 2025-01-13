// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayerStore on _PlayerStore, Store {
  late final _$healthAtom = Atom(name: '_PlayerStore.health', context: context);

  @override
  int get health {
    _$healthAtom.reportRead();
    return super.health;
  }

  @override
  set health(int value) {
    _$healthAtom.reportWrite(value, super.health, () {
      super.health = value;
    });
  }

  late final _$maxHealthAtom =
      Atom(name: '_PlayerStore.maxHealth', context: context);

  @override
  int get maxHealth {
    _$maxHealthAtom.reportRead();
    return super.maxHealth;
  }

  @override
  set maxHealth(int value) {
    _$maxHealthAtom.reportWrite(value, super.maxHealth, () {
      super.maxHealth = value;
    });
  }

  late final _$_PlayerStoreActionController =
      ActionController(name: '_PlayerStore', context: context);

  @override
  void takeDamage(int damage) {
    final _$actionInfo = _$_PlayerStoreActionController.startAction(
        name: '_PlayerStore.takeDamage');
    try {
      return super.takeDamage(damage);
    } finally {
      _$_PlayerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
health: ${health},
maxHealth: ${maxHealth}
    ''';
  }
}
