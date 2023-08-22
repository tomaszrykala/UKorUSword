import 'package:flutter/material.dart';

import '../../repo/words_repo.dart';
import '../../domain/game_controller.dart';
import '../../data/data.dart';

class PlayGamePage extends StatefulWidget {
  const PlayGamePage({super.key, required this.title});

  final String title;

  @override
  State<PlayGamePage> createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage> {
  GameController? _gameController;

  _PlayGamePageState() {
    _loadAllWords();
  }

  void _loadAllWords() async {
    List<Word> allWords = await fetchAllWords();
    setState(() {
      _gameController = GameController(words: allWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: _gameController != null
              ? buildContentColumn(_gameController!.getGameState(), context)
              : const CircularProgressIndicator(
                  semanticsLabel: 'Loading game...',
                )),
    );
  }

  Column buildContentColumn(GameState gameState, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildTitleRow(gameState, context),
        buildButtonsRow(gameState),
        buildScoreRow(gameState, context),
        if (!gameState.finishedAllWords) buildCountDownRow(gameState, context),
      ],
    );
  }

  Container buildTitleRow(GameState gameState, BuildContext context) =>
      Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                gameState.finishedAllWords
                    ? 'Game Over'
                    : 'The term is:\n`${gameState.word!.word}`',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              )
            ],
          ));

  Row buildButtonsRow(GameState gameState) {
    const insets = 16.0;
    if (gameState.finishedAllWords) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialOffButton(Locale.UK)),
          MaterialButton(
            height: 80,
            color: Colors.grey,
            onPressed: () {
              setState(() {
                _gameController!.getRestartGameState();
              });
            },
            child: const Text("Restart?"),
          ),
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialOffButton(Locale.US))
        ],
      );
    } else {
      var word = gameState.word!;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialButton(word, Locale.UK)),
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialButton(word, Locale.US))
        ],
      );
    }
  }

  Container buildScoreRow(GameState gameState, BuildContext context) =>
      Container(
          margin: const EdgeInsets.only(top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your score is: ${gameState.score}',
                style: Theme.of(context).textTheme.headlineSmall,
              )
            ],
          ));

  Container buildCountDownRow(GameState gameState, BuildContext context) {
    var remaining = gameState.remainingWords;
    var text = remaining.isEmpty
        ? 'Last word!'
        : 'Remaining words: ${remaining.length}.';
    return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ],
        ));
  }

  MaterialButton buildMaterialButton(Word word, Locale locale) =>
      MaterialButton(
        height: 80,
        color: locale == Locale.UK ? Colors.redAccent : Colors.lightBlueAccent,
        onPressed: () {
          setState(() {
            _gameController!.checkGuess(word, locale);
          });
        },
        child: Text(locale.name),
      );

  MaterialButton buildMaterialOffButton(Locale locale) => MaterialButton(
        height: 80,
        color: Colors.grey,
        onPressed: () {},
        child: Text(locale.name),
      );
}