import 'package:flutter/material.dart';

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
  int _scoreCounter = 0;
  int _wordsCountdown = 10;
  final List<Word> _words = [];

  _MyHomePageState() {
    _loadCSV();
  }

  void _increaseScore() {
    setState(() {
      _scoreCounter++;
      _wordsCountdown--;
    });
  }

  void _resetScore() {
    setState(() {
      _scoreCounter = 0;
      _wordsCountdown = 10;
    });
  }

  void _loadCSV() async {
    List<Word> allWords = await getAllWords();
    setState(() {
      _words.addAll(allWords);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.

    GameState gameState = getWord(_words, _wordsCountdown);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildTitleRow(gameState, context),
            buildButtonsRow(gameState, _words),
            buildScoreRow(context),
            buildCountDownRow(context),
          ],
        ),
      ),
    );
  }

  Container buildTitleRow(GameState gameState, BuildContext context) =>
      Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                gameState.finished
                    ? 'Game Over'
                    : 'The term is:\n`${gameState.word!.word}`',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              )
            ],
          ));

  Row buildButtonsRow(GameState gameState, List<Word> words) {
    const insets = 16.0;
    if (gameState.finished) {
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
              restartGame(words, () {
                _resetScore();
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
              child: buildMaterialButton(gameState.word!, words, Locale.UK)),
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialButton(gameState.word!, words, Locale.US))
        ],
      );
    }
  }

  Container buildScoreRow(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Your score is: $_scoreCounter',
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ));

  Container buildCountDownRow(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Remaining words: $_wordsCountdown',
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ));

  MaterialButton buildMaterialButton(
          Word word, List<Word> words, Locale locale) =>
      MaterialButton(
        height: 80,
        color: locale == Locale.UK ? Colors.redAccent : Colors.lightBlueAccent,
        onPressed: () {
          // checkGuess(word, locale);
          checkGuess(word, words, locale, () {
            _increaseScore();
          }, () {
            _resetScore();
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
