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
  final List<Word> remainingWords;
  final bool finishedAllWords;
  final bool hasNextWords;

  GameState(
      {required this.word, required this.score, required this.remainingWords})
      : finishedAllWords = remainingWords.isEmpty && word == null,
        hasNextWords = remainingWords.isNotEmpty;
}
