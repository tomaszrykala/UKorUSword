import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../../repo/words_repo.dart';
import '../factory/game_state_factory.dart';
import '../factory/game_words_factory.dart';

class SoloGameController extends StateNotifier<SoloGameState> {
  SoloGameController() : super(createInitSoloGameState());

  final List<Word> _allWords = [];
  final GameWordsFactory _newGameWordsFactory = GameWordsFactory();

  final AutoDisposeStateNotifierProvider<SoloGameController, SoloGameState>
      stateProvider =
      StateNotifierProvider.autoDispose((ref) => SoloGameController.init());

  SoloGameController.init() : super(createInitSoloGameState()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    state = createInitSoloGameState();

    List<Word> allWords = await fetchAllWords();
    _allWords.addAll(allWords);

    _createStartSoloGameState();
  }

  void onRestartGameClicked() {
    _createStartSoloGameState();
  }

  void onWordGuess(Word word, Locale locale) {
    var gameState = state.player.gameState;
    var newScore = word.locale == locale ? gameState.score + 1 : 0;
    state = createCheckWordSoloGameState(word, newScore, gameState.remainingWords);
    _publishSoloGameState();
  }

  void _publishSoloGameState() {
    var gameState = state.player.gameState;
    if (gameState.finishedAllWords) {
      if (gameState.hasRemainingWords) {
        _setNextWordSoloGameState(0);
      } else {
        _resetSoloGameState();
      }
    } else {
      _setNextWordSoloGameState(gameState.score);
    }
  }

  void _setNextWordSoloGameState(int newScore) {
    var gameState = state.player.gameState;
    if (gameState.hasRemainingWords) {
      var remainingWords = gameState.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordSoloGameState(word, newScore, remainingWords);
    } else {
      state = createFinishedSoloGameState(newScore);
    }
  }

  void _resetSoloGameState() {
    state = createInitSoloGameState();
    _publishSoloGameState();
  }

  void _createStartSoloGameState() {
    List<List<Word>> gameWords = _newGameWordsFactory.getNewGameWords(_allWords, 1);
    state = createStartNewSoloGameState(gameWords[0]);
    _publishSoloGameState();
  }
}
