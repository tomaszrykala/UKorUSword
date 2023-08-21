// ignore: constant_identifier_names
enum Locale { US, UK }

final class Word {
  String word;
  Locale locale;

  Word({required this.word, required this.locale});
}

final class GameState {
  Word? word;
  int score;
  bool isFinished;
  List<Word> remainingWords;

  GameState(
      {required this.word,
      required this.score,
      required this.isFinished,
      required this.remainingWords}) {}
}
