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
