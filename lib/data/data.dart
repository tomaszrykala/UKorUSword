// ignore: constant_identifier_names
enum Locale { US, UK }

final class Word {
  final String word;
  final Locale locale;

  Word({required this.word, required this.locale});
}

final class GameState {
  final int score;
  final Word? word;
  final List<Word> remainingWords;
  final bool finishedAllWords;
  final bool hasRemainingWords;

  GameState({required this.score, required this.word, required this.remainingWords})
      : finishedAllWords = remainingWords.isEmpty && word == null,
        hasRemainingWords = remainingWords.isNotEmpty;
}

final class Player {
  final String name;
  final GameState gameState;

  Player({required this.name, required this.gameState});
}

sealed class WordGameState {}

final class SoloGameState extends WordGameState {
  final Player player;

  SoloGameState({required this.player});
}

final class DuelGameState extends WordGameState {
  final bool isPlayer1; // active vs inactive player?
  final Player player1;
  final Player player2;
  final Player activePlayer;
  final bool finishedAllPlayerWords;

  DuelGameState({required this.isPlayer1, required this.player1, required this.player2})
      : activePlayer = isPlayer1 ? player1 : player2,
        finishedAllPlayerWords =
            player1.gameState.finishedAllWords && player2.gameState.finishedAllWords;

  GameState activeGameState() => activePlayer.gameState;
}
