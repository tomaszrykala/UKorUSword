import 'data.dart';

sealed class WordGameState {
  String _remainingLabel(Player player, bool isPlayer1) {
    final remaining = player.gameState.remainingWords;
    final length = remaining.length;
    final remainingLabel = isPlayer1 ? 'remaining [$length]' : '[$length] remaining';
    return remaining.isEmpty ? 'Last word!' : remainingLabel;
  }

  String _currentPlayerLabel(DuelGameState state) {
    if (state._isGameFinished && state._winner != null) {
      final Player? winner = state._winner!.player;
      return winner != null ? 'The winner is ${winner.name}!' : 'It\'s a draw!';
    } else {
      return '${state._activePlayer.name}\'s turn:';
    }
  }
}

final class SoloGameState extends WordGameState {
  // Player State
  final Player player;

  // UI State (unused for now)
  late String playerScoreLabel;
  late String playerRemainingLabel;

  // late String titleLabel;
  // late bool isPlayer1Active;

  SoloGameState({required this.player}) {
    playerScoreLabel = 'score -> ${player.gameState.score}';
    playerRemainingLabel = _remainingLabel(player, true);
  }
}

final class DuelGameState extends WordGameState {
  // Player State
  final Player player1;
  final Player player2;

  // Private State
  final Player _activePlayer;
  final bool _isGameFinished;
  final Winner? _winner;

  // UI State
  late Word? currentWord;
  late String player1NameLabel;
  late String player2NameLabel;
  late String player1ScoreLabel;
  late String player2ScoreLabel;
  late String player1RemainingLabel;
  late String player2RemainingLabel;
  late String currentPlayerLabel;
  late String titleLabel;
  late bool isPlayer1Active;
  late bool showCountDownRow;
  late bool showGameFinishedState;

  DuelGameState.init({required this.player1, required this.player2})
      : _activePlayer = player1,
        _isGameFinished = _isFinished(player1, player2),
        _winner = null {
    _mapUiLabels();
  }

  DuelGameState.updatePlayer(
      {required Player activePlayer, required this.player1, required this.player2})
      : _activePlayer = activePlayer,
        _isGameFinished = _isFinished(player1, player2),
        _winner = null {
    _mapUiLabels();
  }

  DuelGameState.nextPlayer(DuelGameState fromState)
      : _activePlayer = fromState.isPlayer1Active ? fromState.player2 : fromState.player1,
        player1 = fromState.player1,
        player2 = fromState.player2,
        _isGameFinished = _isFinished(fromState.player1, fromState.player2),
        _winner = null {
    _mapUiLabels();
  }

  DuelGameState.finished(
      {required this.player1, required this.player2, required Winner winner})
      : _winner = winner,
        _activePlayer = player2,
        _isGameFinished = true {
    _mapUiLabels();
  }

  static bool _isFinished(Player player1, Player player2) =>
      player1.gameState.isFinished && player2.gameState.isFinished;

  void _mapUiLabels() {
    currentWord = _activePlayer.gameState.word;
    player1RemainingLabel = _remainingLabel(player1, true);
    player2RemainingLabel = _remainingLabel(player2, false);
    player1ScoreLabel = 'score -> ${player1.gameState.score}';
    player2ScoreLabel = '${player2.gameState.score} <- score';
    player1NameLabel = player1.name;
    player2NameLabel = player2.name;
    currentPlayerLabel = _currentPlayerLabel(this);
    isPlayer1Active = _activePlayer == player1;
    showCountDownRow = !_isGameFinished;
    showGameFinishedState = _isGameFinished;
    titleLabel = _mapTitle();
  }

  String _mapTitle() {
    if (currentWord != null) {
      return 'The term is:\n`${currentWord!.word}`';
    } else if (_isGameFinished) {
      return 'Game Over';
    } else {
      return '';
    }
  }

  GameState activeGameState() => _activePlayer.gameState;
}

final class Winner {
  final Player? player;

  Winner({required this.player});
}
