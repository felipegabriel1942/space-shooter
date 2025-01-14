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
                    style: GoogleFonts.pressStart2p(
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Observer(builder: (_) {
                    return Text(
                      game.player.playerStore.score.toString().padLeft(10, '0'),
                      style: GoogleFonts.pressStart2p(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    );
                  })
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health',
                      style: GoogleFonts.pressStart2p(
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final widgetWidth = constraints.maxWidth * 0.5;
                        return SizedBox(
                          width: widgetWidth,
                          height: 30,
                          child: Observer(
                            builder: (_) {
                              return LinearProgressIndicator(
                                value: game.player.playerStore.health /
                                    game.player.playerStore.maxHealth,
                                backgroundColor: Colors.grey,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              );
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
