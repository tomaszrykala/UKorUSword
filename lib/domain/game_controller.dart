import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data.dart';
import '../repo/words_repo.dart';
import 'game_state_factory.dart';

class GameController extends StateNotifier<GameState> {
  GameController() : super(createInitGameState());

  final List<Word> _allWords = [];

  final AutoDisposeStateNotifierProvider<GameController, GameState>
      stateProvider =
      StateNotifierProvider.autoDispose((ref) => GameController.init());

  GameController.init() : super(createInitGameState()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    state = createInitGameState();

    List<Word> allWords = await fetchAllWords();
    _allWords.addAll(allWords);

    _createStartGameState();
  }

  void onRestartGameClicked() {
    _createStartGameState();
  }

  void onWordGuess(Word word, Locale locale) {
    var newScore = word.locale == locale ? state.score + 1 : 0;
    state = createCheckWordGameState(word, newScore, state.remainingWords);
    _publishGameState();
  }

  void _publishGameState() {
    if (state.finishedAllWords) {
      if (state.hasNextWords) {
        _setNextWordGameState(0);
      } else {
        _resetGameState();
      }
    } else {
      _setNextWordGameState(state.score);
    }
  }

  void _setNextWordGameState(int newScore) {
    if (state.hasNextWords) {
      var remainingWords = state.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordGameState(word, newScore, remainingWords);
    } else {
      state = createFinishedGameState(newScore);
    }
  }

  void _resetGameState() {
    state = createInitGameState();
    _publishGameState();
  }

  void _createStartGameState() {
    var newGameWords = _getNewGameWords();
    state = createStartNewGameState(newGameWords);
    _publishGameState();
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
