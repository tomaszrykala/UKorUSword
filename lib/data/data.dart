// ignore: constant_identifier_names
enum Locale { US, UK }

final class Word {
  String word;
  Locale locale;

  Word({required this.word, required this.locale});
}

final class GameState {
  Word? currentWord;
  int currentScore;
  bool isFinished;
  List<Word> remainingWords;
  int wordCountDown = 0;

  GameState(
      {required this.currentWord,
      required this.isFinished,
      required this.currentScore,
      required this.remainingWords}) {
    wordCountDown = remainingWords.length;
  }
}
