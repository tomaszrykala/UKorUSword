import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data.dart';
import '../repo/words_repo.dart';
import 'game_state_factory.dart';

class GameController extends StateNotifier<GameState> {
  GameController() : super(initGameState());

  final List<Word> _allWords = [];

  final AutoDisposeStateNotifierProvider<GameController, GameState>
      riverpodProvider =
      StateNotifierProvider.autoDispose((ref) => GameController.init());

  GameController.init() : super(initGameState()) {
    _fetchData();
  }

  // TODO make all private methods return the state
  Future<void> _fetchData() async {
    state = initGameState();

    List<Word> allWords = await fetchAllWords();
    _allWords.addAll(allWords);

    state = startNewGameState(_getNewGameWords());
  }

  void getGameState() {
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

  void getRestartGameState() {
    _createStartGameState();
  }

  void checkGuess(Word word, Locale locale) {
    var newScore = word.locale == locale ? state.score + 1 : 0;
    state = checkWordGameState(word, newScore, state.remainingWords);
    // return bool?
  }

  void _setNextWordGameState(int newScore) {
    if (state.hasNextWords) {
      var remainingWords = state.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = checkWordGameState(word, newScore, remainingWords);
    } else {
      state = finishedGameState(newScore);
    }
  }

  void _createStartGameState() {
    state = startNewGameState(_getNewGameWords());
  }

  void _resetGameState() {
    state = initGameState();
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
