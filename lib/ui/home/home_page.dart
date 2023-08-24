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
  final TextEditingController _p1NameController = TextEditingController();
  final TextEditingController _p2NameController = TextEditingController();
  var _p1Name = '';
  var _p2Name = '';

  @override
  void dispose() {
    _p1NameController.dispose();
    _p2NameController.dispose();
    super.dispose();
  }

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
            _buildPlayerNameEntryWidget(context),
            _buildStartButtons(context),
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

  Container _buildPlayerNameEntryWidget(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: _gameMode == _GameMode.solo
            ? null
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text('Player 1 name:'),
                      SizedBox(
                        width: 120,
                        height: 60,
                        child: TextFormField(
                          onChanged: (text) => setState(() {
                            _p1Name = text;
                          }),
                          controller: _p1NameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      const Text('Player 2 name:'),
                      SizedBox(
                        width: 120,
                        height: 60,
                        child: TextFormField(
                          onChanged: (text) => setState(() {
                            _p2Name = text;
                          }),
                          controller: _p2NameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
  }

  MaterialButton _buildStartButtons(BuildContext context) {
    if (_gameMode == _GameMode.solo) {
      return _buildStartGameButton(context, true);
    } else {
      if (_p1Name.isNotEmpty && _p2Name.isNotEmpty) {
        return _buildStartGameButton(context, false);
      } else {
        return MaterialButton(
          height: buttonHeight,
          color: Colors.grey,
          onPressed: () {},
          child: const Text('Enter names.'),
        );
      }
    }
  }

  MaterialButton _buildStartGameButton(BuildContext context, bool isSoloMode) =>
      MaterialButton(
          height: buttonHeight,
          color: Colors.yellow,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlayGamePage(
                  title: widget.title,
                  playGameMode: isSoloMode
                      ? PlayGameMode.solo()
                      : PlayGameMode.duel(p1Name: _p1Name, p2Name: _p2Name),
                ),
              ),
            );
          },
          child: const Text('START'));
}
