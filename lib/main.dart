import 'package:flutter/material.dart';

import '../repo/words_repo.dart';
import 'domain/engine.dart';
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
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
        buildCountDownRow(gameState, context),
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
                gameState.isFinished
                    ? 'Game Over'
                    : 'The term is:\n`${gameState.currentWord!.word}`',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              )
            ],
          ));

  Row buildButtonsRow(GameState gameState) {
    const insets = 16.0;
    if (gameState.isFinished) {
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
                _gameController!.onRestartGame();
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
              child: buildMaterialButton(gameState.currentWord!, Locale.UK)),
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialButton(gameState.currentWord!, Locale.US))
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
                'Your score is: ${gameState.currentScore}',
                style: Theme.of(context).textTheme.headlineSmall,
              )
            ],
          ));

  Container buildCountDownRow(GameState gameState, BuildContext context) =>
      Container(
          margin: const EdgeInsets.only(top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Remaining words: ${gameState.wordCountDown}',
                style: Theme.of(context).textTheme.headlineSmall,
              )
            ],
          ));

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
