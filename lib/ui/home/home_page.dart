import 'package:flutter/material.dart';

import '../play_game/play_game_mode.dart';
import '../play_game/play_game_page.dart';
import '../styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

enum _GameMode { solo, duel }

class _HomePageState extends State<HomePage> {
  _GameMode _gameMode = _GameMode.solo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // TODO Scaffold to the app!
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTitle(context),
            _buildGameModeSwitchRow(context),
            // if (_gameMode == GameMode.duel) _buildPlayerNameEntryWidget(context),
            _buildStartButton(context),
          ],
        )));
  }

  Text _buildTitle(BuildContext context) =>
      Text('Game Mode:', style: Theme.of(context).textTheme.headlineLarge);

  Container _buildGameModeSwitchRow(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Text('Solo',
                  style: Theme.of(context).textTheme.headlineSmall)),
          Switch(
              // This bool value toggles the switch.
              value: _gameMode == _GameMode.duel,
              activeColor: Colors.red,
              onChanged: (bool isDuelMode) {
                setState(() {
                  _gameMode = isDuelMode ? _GameMode.duel : _GameMode.solo;
                });
              }),
          Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: Text('Duel',
                  style: Theme.of(context).textTheme.headlineSmall))
        ],
      ));

  // TODO
  Container _buildPlayerNameEntryWidget(BuildContext context) =>
      Container(margin: const EdgeInsets.only(bottom: 24), child: null);

  MaterialButton _buildStartButton(BuildContext context) {
    var isSoloMode = _gameMode == _GameMode.solo; // ..&& names are present!

    if (isSoloMode) {
      return MaterialButton(
          height: buttonHeight,
          color: Colors.yellow,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlayGamePage(
                  title: widget.title,
                  playGameMode: isSoloMode
                      ? PlayGameMode.solo()
                      : PlayGameMode.duel(
                          p1Name: 'Player 1', p2Name: 'Player 2'),
                ),
              ),
            );
          },
          child:
              const Text('START') // if P2mode and names not set, active = false
          );
    } else {
      return MaterialButton(
        height: buttonHeight,
        color: Colors.grey,
        onPressed: () {},
        child: const Text('Not supported yet.'),
      );
    }
  }
}
