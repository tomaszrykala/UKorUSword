import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../../repo/words_repo.dart';
import '../game_state_factory.dart';

class DuelGameController extends StateNotifier<DuelGameState> {
  DuelGameController({required String p1Name, required String p2Name})
      : _p1Name = p1Name,
        _p2Name = p2Name,
        super(createInitDuelGameState(p1Name, p2Name));

  String _p1Name;
  String _p2Name;
  final List<Word> _allWords = [];
  var _isPlayerOne = true;

  final AutoDisposeStateNotifierProvider<DuelGameController, DuelGameState>
      stateProvider = StateNotifierProvider.autoDispose(
          (ref) => DuelGameController.init("Player 1", "Player 2"));

  DuelGameController.init(this._p1Name, this._p2Name)
      : super(createInitDuelGameState(_p1Name, _p2Name)) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    state = createInitDuelGameState(_p1Name, _p2Name);

    List<Word> allWords = await fetchAllWords();
    _allWords.addAll(allWords);

    _createStartDuelGameState();
  }

  void setNames(String p1Name, String p2Name) {
    if (_p1Name != p1Name && _p2Name != p2Name) {
      _p1Name = p1Name;
      _p2Name = p2Name;

      var p1Words = state.player1.gameState.remainingWords;
      var p2Words = state.player2.gameState.remainingWords;
      state = createStartNewDuelGameState(p1Words, p2Words, p1Name, p2Name);
      _publishDuelGameState();

      // state = createInitDuelGameState(_p1Name, _p2Name);
      // _createStartDuelGameState();
    }
  }

  void onRestartGameClicked() {
    _createStartDuelGameState();
  }

  void onWordGuess(Word word, Locale locale) {
    GameState gameState = _getGameState();
    var newScore = word.locale == locale ? gameState.score + 1 : 0;
    state = createCheckWordDuelGameState(
        word, newScore, gameState.remainingWords, _isPlayerOne, _p1Name, _p2Name);
    _publishDuelGameState();
  }

  GameState _getGameState() =>
      _isPlayerOne ? state.player1.gameState : state.player2.gameState;

  void _publishDuelGameState() {
    GameState gameState = _getGameState();
    if (gameState.finishedAllWords) {
      if (gameState.hasNextWords) {
        _setNextWordDuelGameState(0);
      } else {
        _resetDuelGameState();
      }
    } else {
      _setNextWordDuelGameState(gameState.score);
    }
    // _isPlayerOne = !_isPlayerOne;
  }

  void _setNextWordDuelGameState(int newScore) {
    GameState gameState = _getGameState();
    if (gameState.hasNextWords) {
      var remainingWords = gameState.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordDuelGameState(
          word, newScore, remainingWords, _isPlayerOne, _p1Name, _p2Name);
    } else {
      state = createFinishedDuelGameState(newScore, _isPlayerOne, _p1Name, _p2Name);
    }
  }

  void _resetDuelGameState() {
    state = createInitDuelGameState(_p1Name, _p2Name);
    _publishDuelGameState();
  }

  void _createStartDuelGameState() {
    _DuelNewGameWords newGameWords = _getNewGameWords();
    state = createStartNewDuelGameState(
        newGameWords.p1Words, newGameWords.p2Words, _p1Name, _p2Name);
    _publishDuelGameState();
  }

  _DuelNewGameWords _getNewGameWords() {
    // // DEBUG?
    // if (_allWords.isEmpty) {
    //   return _DuelNewGameWords([], []);
    // }
    const playerCount = 2;
    List<int> unseenWordsIndices = [];
    List<List<Word>> newGameWords = [[], []];
    for (int playerIndex = 0; playerIndex < playerCount; playerIndex++) {
      for (int i = 0; unseenWordsIndices.length < 10; i++) {
        int currentWordIndex = Random().nextInt(_allWords.length);
        if (!unseenWordsIndices.contains(currentWordIndex)) {
          var unseenWord = _allWords[currentWordIndex];
          newGameWords[playerIndex].add(unseenWord);
          unseenWordsIndices.add(currentWordIndex);
        }
      }
    }
    return _DuelNewGameWords(newGameWords[0], newGameWords[1]);
  }
}

final class _DuelNewGameWords {
  final List<Word> p1Words;
  final List<Word> p2Words;

  _DuelNewGameWords(this.p1Words, this.p2Words);
}
