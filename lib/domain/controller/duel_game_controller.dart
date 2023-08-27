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

  void onWordGuess(Word word, Locale locale) {
    GameState gameState = state.getCurrentGameState();
    var newScore = word.locale == locale ? gameState.score + 1 : 0;

    // check player guess
    state = createCheckWordDuelGameState(word, newScore, gameState.remainingWords, state);

    // change player
    state = DuelGameState(
        isPlayer1: !state.isPlayer1, player1: state.player1, player2: state.player2);

    _publishGameState();
  }

  void _publishGameState() {
    GameState gameState = state.getCurrentGameState();
    if (gameState.finishedAllWords) {
      if (gameState.hasRemainingWords) {
        _setNextWordGameState(0);
      } else {
        _resetGameState();
      }
    } else {
      _setNextWordGameState(gameState.score);
    }
  }

  void _setNextWordGameState(int newScore) {
    GameState gameState = state.getCurrentGameState();
    if (gameState.hasRemainingWords) {
      var remainingWords = gameState.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordDuelGameState(word, newScore, remainingWords, state);
    } else {
      if (state.playingLastPlayerLastWord) {
        // Playing last Player's last word. The next state will be FinishedGameState.
      } else {
        state = createFinishedDuelGameState(newScore, state);
      }
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
}