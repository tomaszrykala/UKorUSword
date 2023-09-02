import 'data.dart';

sealed class _WordGameState {
  final Word? currentWord;
  final bool _isGameFinished;

  _WordGameState(this.currentWord, this._isGameFinished);

  String _remainingLabel(Player player, bool isPlayer1) {
    final remaining = player.gameState.remainingWords;
    final length = remaining.length;
    final remainingLabel = isPlayer1 ? 'remaining [$length]' : '[$length] remaining';
    return remaining.isEmpty ? 'Last word!' : remainingLabel;
  }

  String _playerScoreLabel(Player player, bool isPlayer1) {
    var score = player.gameState.score;
    return isPlayer1 ? 'score -> $score' : '$score <- score';
  }

  String _mapTitle(Word? currentWord, bool isGameFinished) {
    if (currentWord != null) {
      return 'The term is:\n`${currentWord.word}`';
    } else if (isGameFinished) {
      return 'Game Over';
    } else {
      return '';
    }
  }
}

final class SoloGameState extends _WordGameState {
  // Game State
  final Player player;

  // UI State
  late String playerRemainingLabel;
  late String playerScoreLabel;
  late bool showCountDownRow;
  late String titleLabel;
  late bool showGameFinishedState;

  SoloGameState({required this.player})
      : super(player.gameState.word, player.gameState.isFinished) {
    _mapUiLabels();
  }

  void _mapUiLabels() {
    playerRemainingLabel = _remainingLabel(player, true);
    playerScoreLabel = _playerScoreLabel(player, true);
    showCountDownRow = !_isGameFinished;
    showGameFinishedState = _isGameFinished;
    titleLabel = _mapTitle(currentWord, _isGameFinished);
  }
}

final class DuelGameState extends _WordGameState {
  // Game State
  final Player player1;
  final Player player2;

  // Private State
  final Player _activePlayer;
  final Winner? _winner;

  // UI State
  late String player1NameLabel;
  late String player2NameLabel;
  late String player1ScoreLabel;
  late String player2ScoreLabel;
  late String player1RemainingLabel;
  late String player2RemainingLabel;
  late String currentPlayerLabel;
  late String titleLabel;
  late bool showCountDownRow;
  late bool isPlayer1Active;
  late bool showGameFinishedState;

  DuelGameState.init({required this.player1, required this.player2})
      : _activePlayer = player1,
        _winner = null,
        super(player1.gameState.word, _isFinished(player1, player2)) {
    _mapUiLabels();
  }

  DuelGameState.updatePlayer(
      {required Player activePlayer, required this.player1, required this.player2})
      : _activePlayer = activePlayer,
        _winner = null,
        super(activePlayer.gameState.word, _isFinished(player1, player2)) {
    _mapUiLabels();
  }

  DuelGameState.nextPlayer(DuelGameState fromState)
      : _activePlayer = fromState.isPlayer1Active ? fromState.player2 : fromState.player1,
        player1 = fromState.player1,
        player2 = fromState.player2,
        _winner = null,
        super(
            fromState.isPlayer1Active
                ? fromState.player2.gameState.word
                : fromState.player1.gameState.word,
            _isFinished(fromState.player1, fromState.player2)) {
    _mapUiLabels();
  }

  DuelGameState.finished(
      {required this.player1, required this.player2, required Winner winner})
      : _winner = winner,
        _activePlayer = player2,
        super(player2.gameState.word, true) {
    _mapUiLabels();
  }

  static bool _isFinished(Player player1, Player player2) =>
      player1.gameState.isFinished && player2.gameState.isFinished;

  void _mapUiLabels() {
    player1RemainingLabel = _remainingLabel(player1, true);
    player2RemainingLabel = _remainingLabel(player2, false);
    player1ScoreLabel = _playerScoreLabel(player1, true);
    player2ScoreLabel = _playerScoreLabel(player2, false);
    player1NameLabel = player1.name;
    player2NameLabel = player2.name;
    currentPlayerLabel = _currentPlayerLabel(this);
    isPlayer1Active = _activePlayer == player1;
    showCountDownRow = !_isGameFinished;
    showGameFinishedState = _isGameFinished;
    titleLabel = _mapTitle(currentWord, _isGameFinished);
  }

  GameState activeGameState() => _activePlayer.gameState;

  String _currentPlayerLabel(DuelGameState state) {
    if (state._isGameFinished && state._winner != null) {
      final Player? winner = state._winner!.player;
      return winner != null ? 'The winner is ${winner.name}!' : 'It\'s a draw!';
    } else {
      return '${state._activePlayer.name}\'s turn:';
    }
  }
}

final class Winner {
  final Player? player;

  Winner({required this.player});
}
