import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:space_shooter/game/space_shooter_game.dart';

class Hud extends StatelessWidget {
  final SpaceShooterGame game;

  const Hud({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score',
                    style: GoogleFonts.pressStart2p(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '000000',
                    style: GoogleFonts.pressStart2p(
                      textStyle: const TextStyle(fontSize: 25),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health',
                    style: GoogleFonts.pressStart2p(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    height: 30,
                    child: Observer(
                      builder: (_) {
                        return LinearProgressIndicator(
                          value: game.player.playerStore.health /
                              game.player.playerStore.maxHealth,
                          backgroundColor: Colors.grey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.red),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
