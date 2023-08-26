import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../../repo/words_repo.dart';
import '../factory/game_state_factory.dart';
import '../factory/game_words_factory.dart';

class SoloGameController extends StateNotifier<SoloGameState> {
  SoloGameController() : super(createInitSoloGameState());

  final List<Word> _allWords = [];
  late AutoDisposeStateNotifierProvider<SoloGameController, SoloGameState> stateProvider;

  SoloGameController.init() : super(createInitSoloGameState()) {
    stateProvider = StateNotifierProvider.autoDispose((ref) => this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Word> allWords = await fetchAllWords();
    _allWords.addAll(allWords);

    _createStartGameState();
  }

  void onRestartGameClicked() {
    _createStartGameState();
  }

  void onWordGuess(Word word, Locale locale) {
    var gameState = state.player.gameState;
    var newScore = word.locale == locale ? gameState.score + 1 : 0;
    state = createCheckWordSoloGameState(word, newScore, gameState.remainingWords);
    _publishGameState();
  }

  void _publishGameState() {
    var gameState = state.player.gameState;
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

  void _resetGameState() {
    state = createInitSoloGameState();
    _publishGameState();
  }

  void _createStartGameState() {
    final List<List<Word>> gameWords = _getNewGameWords();
    state = createStartNewSoloGameState(gameWords[0]);
    _publishGameState();
  }

  List<List<Word>> _getNewGameWords() {
    final gameWordsFactory = GameWordsFactory(); // TODO inject
    return gameWordsFactory.getNewGameWords(_allWords, 1);
  }
}
