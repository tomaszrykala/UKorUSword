import 'package:flutter/material.dart';

import '../repo/words_repo.dart';
import 'domain/game_controller.dart';
import 'data/data.dart';

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
      home: const MyHomePage(title: 'UK or US Word?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GameController? _gameController;

  _MyHomePageState() {
    _loadCSV();
  }

  void _loadCSV() async {
    List<Word> allWords = await fetchAllWords();
    setState(() {
      _gameController = GameController(words: allWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_gameController != null) {
      GameState gameState = _gameController!.getGameState();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: buildContentColumn(gameState, context),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const Center(), // TODO CSQ .. loading
      );
    }
  }

  Column buildContentColumn(GameState gameState, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildTitleRow(gameState, context),
        buildButtonsRow(gameState),
        buildScoreRow(gameState, context),
        if (!gameState.finishedLastWord) buildCountDownRow(gameState, context),
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
                gameState.finishedLastWord
                    ? 'Game Over'
                    : 'The term is:\n`${gameState.word!.word}`',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              )
            ],
          ));

  Row buildButtonsRow(GameState gameState) {
    const insets = 16.0;
    if (gameState.finishedLastWord) {
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialButton(gameState.word!, Locale.UK)),
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialButton(gameState.word!, Locale.US))
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
