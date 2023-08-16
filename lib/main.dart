import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final testWords = [
      Word(word: "pavement", locale: Locale.UK),
      Word(word: "sidewalk", locale: Locale.US),
      Word(word: "'ground' <- beef", locale: Locale.US),
      Word(word: "turkey -> 'mince'", locale: Locale.UK),
    ];

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
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        words: testWords,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.words});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final List<Word> words;

  @override
  State<MyHomePage> createState() => _MyHomePageState(words);
}

class _MyHomePageState extends State<MyHomePage> {
  int _scoreCounter = 0;
  List<Word> _words = [];

  _MyHomePageState(List<Word> words) {
    _words = words;
  }

  void _updateScore(bool guessed) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (guessed) {
        _scoreCounter++;
      } else {
        _scoreCounter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.

    Word word = _words.random();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'The term is:\n${word.word}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(16),
                    child: buildMaterialButton(word, Locale.UK)),
                Container(
                    margin: const EdgeInsets.all(16),
                    child: buildMaterialButton(word, Locale.US))
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Your score is: $_scoreCounter',
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  MaterialButton buildMaterialButton(Word word, Locale locale) {
    var color = locale == Locale.UK ? Colors.redAccent : Colors.lightBlueAccent;
    return MaterialButton(
      height: 80,
      color: color,
      onPressed: () {
        checkGuess(word, locale);
      },
      child: Text(locale.name),
    );
  }

  void checkGuess(Word word, Locale locale) {
    _updateScore(word.locale == locale);
  }
}

enum Locale { US, UK }

final class Word {
  String word;
  Locale locale;
  bool seen = false;

  Word({required this.word, required this.locale});
}

extension WordListRandomPick on List<Word> {
  Word random() {
    if (isNotEmpty) {
      int index = Random().nextInt(length);
      return this[index];
    } else {
      return Word(word: "Error", locale: Locale.UK);
    }
  }
}
