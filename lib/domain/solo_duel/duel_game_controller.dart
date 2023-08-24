import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../../repo/words_repo.dart';
import '../game_state_factory.dart';

class DuelGameController extends StateNotifier<DuelGameState> {
  DuelGameController() : super(createInitDuelGameState());

  final List<Word> _allWords = [];

  final AutoDisposeStateNotifierProvider<DuelGameController, DuelGameState>
      stateProvider =
      StateNotifierProvider.autoDispose((ref) => DuelGameController.init());

  DuelGameController.init() : super(createInitDuelGameState()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    state = createInitDuelGameState();

    List<Word> allWords = await fetchAllWords();
    _allWords.addAll(allWords);

    _createStartDuelGameState();
  }

  void onRestartGameClicked() {
    _createStartDuelGameState();
  }

  void onWordGuess(Word word, Locale locale) {
    var gameState = state.player1.gameState;
    var newScore = word.locale == locale ? gameState.score + 1 : 0;
    state =
        createCheckWordDuelGameState(word, newScore, gameState.remainingWords);
    _publishDuelGameState();
  }

  void _publishDuelGameState() {
    var gameState = state.player1.gameState;
    if (gameState.finishedAllWords) {
      if (gameState.hasNextWords) {
        _setNextWordDuelGameState(0);
      } else {
        _resetDuelGameState();
      }
    } else {
      _setNextWordDuelGameState(gameState.score);
    }
  }

  void _setNextWordDuelGameState(int newScore) {
    var gameState = state.player1.gameState;
    if (gameState.hasNextWords) {
      var remainingWords = gameState.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordDuelGameState(word, newScore, remainingWords);
    } else {
      state = createFinishedDuelGameState(newScore);
    }
  }

  void _resetDuelGameState() {
    state = createInitDuelGameState();
    _publishDuelGameState();
  }

  void _createStartDuelGameState() {
    var newGameWords = _getNewGameWords();
    state = createStartNewDuelGameState(newGameWords);
    _publishDuelGameState();
  }

  List<Word> _getNewGameWords() {
    List<Word> gameWords = [];
    List<int> unseenWordsIndices = [];
    for (int i = 0; unseenWordsIndices.length < 10; i++) {
      // adds 11 words..
      int currentWordIndex = Random().nextInt(_allWords.length);
      if (!unseenWordsIndices.contains(currentWordIndex)) {
        var unseenWord = _allWords[currentWordIndex];
        gameWords.add(unseenWord);
        unseenWordsIndices.add(currentWordIndex);
      }
    }
    return gameWords;
  }
}
