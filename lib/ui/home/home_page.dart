import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../play_game/play_game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => ProviderScope(
        child: HomeRiverpod(title: title),
      );
}

// - X Choose game mode:
// solo <switcher> duel
// if (duel)
// P1 name P2 name
// [ ] [ ]
// - X 'START'

class HomeRiverpod extends ConsumerWidget {
  HomeRiverpod({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Center(child: _buildContentColumn(context)));
  }

  Column _buildContentColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTitleRow(context),
        // .. TODO
        _buildStartButton(context),
      ],
    );
  }

  Container _buildTitleRow(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Choose Game mode:',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          )
        ],
      ));

  MaterialButton _buildStartButton(BuildContext context) => MaterialButton(
        height: 80,
        color: Colors.yellow,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayGamePage(title: title),
            ),
          );
        },
        child: const Text('START'),
      );
}
