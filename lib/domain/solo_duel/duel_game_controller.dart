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

  void onRestartGameClicked() {
    _createStartDuelGameState();
  }

  void onWordGuess(Word word,Locale locale) {
    GameState gameState = state.getCurrentGameState();
    var newScore = word.locale == locale ? gameState.score + 1 : 0;
    state = createCheckWordDuelGameState(
        word, newScore, gameState.remainingWords, _isPlayerOne, state);

    print("published state of _isPlayerOne: $_isPlayerOne.");
    // print("onWordGuess of _isPlayer1: ${state.player1.gameState.remainingWords.length}");
    // print("onWordGuess of _isPlayer2: ${state.player2.gameState.remainingWords.length}");

    _isPlayerOne = !_isPlayerOne;
    _publishDuelGameState();
    // _isPlayerOne = !_isPlayerOne;
  }

  void _publishDuelGameState() {
    GameState gameState = state.getCurrentGameState();
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
    // print("publishing state of _isPlayerOne: $_isPlayerOne.");
  }

  void _setNextWordDuelGameState(int newScore) {
    GameState gameState = state.getCurrentGameState();
    if (gameState.hasNextWords) {
      var remainingWords = gameState.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordDuelGameState(
          word, newScore, remainingWords, _isPlayerOne, state);

      print("published newScore: $newScore.");
      print("_setNextWordDuelGameState of _isPlayer1: ${state.player1.gameState
          .remainingWords.length}");
      print("_setNextWordDuelGameState of _isPlayer2: ${state.player2.gameState
          .remainingWords.length}");
    } else {
      state = createFinishedDuelGameState(newScore, _isPlayerOne, state);
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
    const playerCount = 2;
    List<int> unseenWordsIndices = [];
    List<List<Word>> newGameWords = [[], []];
    for (int playerIndex = 0; playerIndex < playerCount; playerIndex++) {
      for (int i = 0; i < 10; i++) {
        int currentWordIndex = Random().nextInt(_allWords.length);
        if (!unseenWordsIndices.contains(currentWordIndex)) {
          var unseenWord = _allWords[currentWordIndex];
          newGameWords[playerIndex].add(unseenWord);
          unseenWordsIndices.add(currentWordIndex);
        } else {
          i--;
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
