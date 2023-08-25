import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../../repo/words_repo.dart';
import '../game_state_factory.dart';

class SoloGameController extends StateNotifier<SoloGameState> {
  SoloGameController() : super(createInitSoloGameState());

  final List<Word> _allWords = [];

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
    var newGameWords = _getNewGameWords();
    state = createStartNewSoloGameState(newGameWords);
    _publishSoloGameState();
  }

  List<Word> _getNewGameWords() {
    List<Word> gameWords = [];
    List<int> unseenWordsIndices = [];
    for (int i = 0; i < 10; i++) {
      int currentWordIndex = Random().nextInt(_allWords.length);
      if (!unseenWordsIndices.contains(currentWordIndex)) {
        var unseenWord = _allWords[currentWordIndex];
        gameWords.add(unseenWord);
        unseenWordsIndices.add(currentWordIndex);
      } else {
        i--;
      }
    }
    return gameWords;
  }
}
