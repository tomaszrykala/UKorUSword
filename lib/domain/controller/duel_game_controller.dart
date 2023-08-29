import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/game_module.dart';
import '../../data/data.dart';
import '../factory/game_state_factory.dart';
import '../factory/game_words_factory.dart';

class DuelGameController extends StateNotifier<DuelGameState> {
  DuelGameController({required String p1Name, required String p2Name})
      : _p1Name = p1Name,
        _p2Name = p2Name,
        super(createInitDuelGameState(p1Name, p2Name));

  final String _p1Name;
  final String _p2Name;
  late final GameWordsFactory _gameWordsFactory;
  late final AutoDisposeStateNotifierProvider<DuelGameController, DuelGameState>
      stateProvider;

  DuelGameController.init(this._p1Name, this._p2Name)
      : super(createInitDuelGameState(_p1Name, _p2Name)) {
    stateProvider = StateNotifierProvider.autoDispose((ref) => this);
    _gameWordsFactory = GameModule.instance.gameWordsFactory();
    onRestartGameClicked();
  }

  void onRestartGameClicked() {
    _createStartGameState();
  }

  void onWordGuess(Locale locale) {
    final word = state.currentWord;
    if (word != null) {
      GameState gameState = state.activeGameState();
      final newScore = word.locale == locale ? gameState.score + 1 : gameState.score;

      // check player guess
      state =
          createCheckWordDuelGameState(word, newScore, gameState.remainingWords, state);

      // change player
      state = DuelGameState.nextPlayer(state);

      _publishGameState();
    }
  }

  void _publishGameState() {
    GameState gameState = state.activeGameState();
    if (gameState.isFinished) {
      if (gameState.hasMoreWords) {
        _setNextWordGameState(0);
      } else {
        _resetGameState();
      }
    } else {
      _setNextWordGameState(gameState.score);
    }
  }

  void _setNextWordGameState(int newScore) {
    GameState gameState = state.activeGameState();
    if (gameState.hasMoreWords) {
      final remainingWords = gameState.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordDuelGameState(word, newScore, remainingWords, state);
    } else {
      state = createFinishedDuelGameState(state, _getWinnerLabel());
    }
  }

  void _resetGameState() {
    state = createInitDuelGameState(_p1Name, _p2Name);
    _publishGameState();
  }

  void _createStartGameState() {
    final List<List<Word>> gameWords = _gameWordsFactory.getNewGameWords(2);
    state = createStartNewDuelGameState(gameWords[0], gameWords[1], _p1Name, _p2Name);
    _publishGameState();
  }

  Winner _getWinnerLabel() {
    // could go to factory
    final winnerScore =
        state.player1.gameState.score.compareTo(state.player2.gameState.score);
    if (winnerScore > 0) {
      return Winner(player: state.player1);
    } else if (winnerScore < 0) {
      return Winner(player: state.player2);
    } else {
      return Winner(player: null);
    }
  }
}
