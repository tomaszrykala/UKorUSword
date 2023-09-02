import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/word_game_state.dart';
import '../../di/game_module.dart';
import '../../data/data.dart';
import '../factory/game_state_factory.dart';
import '../factory/game_words_factory.dart';

class SoloGameController extends StateNotifier<SoloGameState> {
  SoloGameController() : super(createInitSoloGameState());

  late final GameWordsFactory _gameWordsFactory;
  late final AutoDisposeStateNotifierProvider<SoloGameController, SoloGameState>
      stateProvider;

  SoloGameController.init() : super(createInitSoloGameState()) {
    stateProvider = StateNotifierProvider.autoDispose((ref) => this);
    _gameWordsFactory = GameModule.instance.gameWordsFactory();
    onRestartGameClicked();
  }

  void onRestartGameClicked() {
    _createStartGameState();
  }

  void onWordGuess(Locale locale) {
    final word = state.currentWord();
    if (word != null) {
      var gameState = state.player.gameState;
      var newScore = word.locale == locale ? gameState.score + 1 : gameState.score;

      state = createCheckWordSoloGameState(word, newScore, gameState.remainingWords);

      _publishGameState();
    }
  }

  void _publishGameState() {
    final gameState = state.player.gameState;
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
    var gameState = state.player.gameState;
    if (gameState.hasMoreWords) {
      var remainingWords = gameState.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordSoloGameState(word, newScore, remainingWords);
    } else {
      state = createFinishedSoloGameState(state);
    }
  }

  void _resetGameState() {
    state = createInitSoloGameState();
    _publishGameState();
  }

  void _createStartGameState() {
    final List<List<Word>> gameWords = _gameWordsFactory.getNewGameWords(1);
    state = createStartNewSoloGameState(gameWords[0]);
    _publishGameState();
  }
}
