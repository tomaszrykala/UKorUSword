// ignore: constant_identifier_names
enum Locale { US, UK }

final class Word {
  final String word;
  final Locale locale;

  Word({required this.word, required this.locale});
}

final class GameState {
  final Word? word;
  final int score;
  final bool isFinished; // TODO remove
  final List<Word> remainingWords;
  final bool finishedLastWord;

  GameState(
      {required this.word,
      required this.score,
      required this.isFinished,
      required this.remainingWords})
      : finishedLastWord = remainingWords.isEmpty && word == null;
}
