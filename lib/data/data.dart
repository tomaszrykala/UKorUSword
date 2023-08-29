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
  final bool isFinished;
  final bool hasMoreWords;

  GameState({required this.score, required this.word, required this.remainingWords})
      : isFinished = remainingWords.isEmpty && word == null,
        hasMoreWords = remainingWords.isNotEmpty;
}

final class Player {
  final String name;
  final GameState gameState;

  Player({required this.name, required this.gameState});

  Player.finished(Player player)
      : name = player.name,
        gameState =
            GameState(word: null, score: player.gameState.score, remainingWords: []);
}

sealed class WordGameState {}

final class SoloGameState extends WordGameState {
  final Player player;

  SoloGameState({required this.player});
}

final class DuelGameState extends WordGameState {
  final Player player1;
  final Player player2;
  final Player activePlayer;
  final bool isGameFinished;
  final Winner? winner;

  DuelGameState(
      {required this.activePlayer, required this.player1, required this.player2})
      : isGameFinished = player1.gameState.isFinished && player2.gameState.isFinished,
        winner = null;

  DuelGameState.init({required this.player1, required this.player2})
      : activePlayer = player1,
        isGameFinished = player1.gameState.isFinished && player2.gameState.isFinished,
        winner = null;

  DuelGameState.finished(
      {required this.player1, required this.player2, required this.winner})
      : activePlayer = player2,
        isGameFinished = true;

  GameState activeGameState() => activePlayer.gameState;
}

final class Winner {
  final Player? player;

  Winner({required this.player});
}
