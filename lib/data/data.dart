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

  GameState({required this.word, required this.score, required this.remainingWords})
      : finishedAllWords = remainingWords.isEmpty && word == null,
        hasNextWords = remainingWords.isNotEmpty;
}

final class DuelPlayer {
  final String name;
  final GameState gameState;

  DuelPlayer({required this.name, required this.gameState});
}

sealed class WordGameState {}

final class SoloGameState extends WordGameState {
  final DuelPlayer player;

  SoloGameState({required this.player});
}

final class DuelGameState extends WordGameState {
  final bool isPlayer1;
  final DuelPlayer player1;
  final DuelPlayer player2;
  // final bool finishedAllDuelWords;

  DuelGameState({required this.isPlayer1, required this.player1, required this.player2});
      // : finishedAllDuelWords =player1.gameState.finishedAllWords && player2.gameState.finishedAllWords;

  DuelPlayer getCurrentPlayer() => isPlayer1 ? player1 : player2;

  GameState getCurrentGameState() => getCurrentPlayer().gameState;

  String getCurrentPlayerName() => getCurrentPlayer().name;

  bool finishedAllDuelWords() =>
      player1.gameState.finishedAllWords && player2.gameState.finishedAllWords;
}
