import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(const UkOrUsWord());
}

class UkOrUsWord extends StatelessWidget {
  const UkOrUsWord({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'UK or US Word?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _scoreCounter = 0;
  final List<Word> _words = [];

  _MyHomePageState() {
    _loadCSV();
  }

  void _increaseScore() {
    setState(() {
      _scoreCounter++;
    });
  }

  void _resetScore() {
    setState(() {
      _scoreCounter = 0;
    });
  }

  void _loadCSV() async {
    List<Word> allWords = await getAllWords();
    setState(() {
      _words.addAll(allWords);
    });
  }

  Future<List<Word>> getAllWords() async {
    final rawData = await rootBundle.loadString("assets/words.csv");
    List<List<dynamic>> csvData =
        const CsvToListConverter(eol: ";", allowInvalid: false)
            .convert(rawData);
    return mapAllWords(csvData);
  }

  List<Word> mapAllWords(List<List<dynamic>> csvData) {
    List<Word> allWords = [];
    for (var wordData in csvData) {
      if (wordData.length == 2) {
        var localeData = wordData[1];
        var locale = Locale.UK.name == localeData ? Locale.UK : Locale.US;
        var word = wordData[0].toString().replaceAll("\n", "");
        allWords.add(Word(word: word, locale: locale));
      }
    }
    return allWords;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.

    GameState gameState = getWord(_words);
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
            buildScoreRow(context)
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
                      : 'The term is:\n${gameState.word!.word}',
                  style: Theme.of(context).textTheme.headlineLarge)
            ],
          ));

  Row buildButtonsRow(GameState gameState, List<Word> allWords) {
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
              for (var word in allWords) {
                word.seen = false;
              }
              _resetScore();
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

  MaterialButton buildMaterialButton(Word word, Locale locale) =>
      MaterialButton(
        height: 80,
        color: locale == Locale.UK ? Colors.redAccent : Colors.lightBlueAccent,
        onPressed: () {
          checkGuess(word, locale);
        },
        child: Text(locale.name),
      );

  MaterialButton buildMaterialOffButton(Locale locale) => MaterialButton(
        height: 80,
        color: Colors.grey,
        onPressed: () {},
        child: Text(locale.name),
      );

  void checkGuess(Word word, Locale locale) {
    if (word.locale == locale) {
      _increaseScore();
    } else {
      _resetScore();
    }
  }
}

GameState getWord(List<Word> words) {
  Word? word = words.random();
  if (word == null) {
    return GameState(word: null, finished: true);
  } else {
    return GameState(word: word, finished: false);
  }
}

// ignore: constant_identifier_names
enum Locale { US, UK }

final class Word {
  String word;
  Locale locale;
  bool seen = false;

  Word({required this.word, required this.locale});
}

final class GameState {
  Word? word;
  bool finished = false;

  GameState({required this.word, required this.finished});
}

extension UnseenWordRandomPick on List<Word> {
  Word? random() {
    var unseenWords = where((element) => !element.seen).toList();
    if (unseenWords.isNotEmpty) {
      int index = Random().nextInt(unseenWords.length);
      var word = unseenWords[index];
      firstWhere((element) => element == word).seen = true;
      return word;
    } else {
      return null;
    }
  }
}
