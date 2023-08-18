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