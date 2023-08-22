import 'package:flutter/material.dart';

import 'ui/play_game/play_game_page.dart';

void main() {
  runApp(const UkOrUsWord());
}

class UkOrUsWord extends StatelessWidget {
  const UkOrUsWord({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UK or US Word?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PlayGamePage(title: 'UK or US Word?'),
    );
  }
}
