import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'play_game_mode.dart';
import 'play_game_riverpod.dart';
import 'solo_duel/solo_game_riverpod.dart';

class PlayGamePage extends StatelessWidget {
  const PlayGamePage(
      {super.key, required this.title, required this.playGameMode});

  final String title;
  final PlayGameMode playGameMode;

  @override
  Widget build(BuildContext context) => ProviderScope(
        child: playGameMode.isDuelMode
            ? PlayGameRiverpod(title: title) // old
            : SoloPlayGameRiverpod(title: title), // new
      );
}
