import 'package:flutter/material.dart';
import 'di/game_module.dart';
import 'ui/home/home_page.dart';

void main() {
  runApp(const UkOrUsWord());
  GameModule.instance.wordsRepository().init();
}

class UkOrUsWord extends StatelessWidget {
  const UkOrUsWord({super.key});

  static const _title = 'UK or US Word?';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: _title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const HomePage(title: _title),
      );
}
