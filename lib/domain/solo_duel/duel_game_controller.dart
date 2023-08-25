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

  void onWordGuess(Word word, Locale locale) {
    GameState gameState = state.getCurrentGameState();
    var newScore = word.locale == locale ? gameState.score + 1 : 0;
    state = createCheckWordDuelGameState(word, newScore, gameState.remainingWords, state);

    print("state.isPlayer1: ${state.isPlayer1}.");
    state = DuelGameState(
        isPlayer1: !state.isPlayer1, player1: state.player1, player2: state.player2);

    _publishDuelGameState();
  }

  void _publishDuelGameState() {
    GameState gameState = state.getCurrentGameState();
    if (gameState.finishedAllWords) {
      if (gameState.hasRemainingWords) {
        _setNextWordDuelGameState(0);
      } else {
        _resetDuelGameState();
      }
    } else {
      _setNextWordDuelGameState(gameState.score);
    }
  }

  void _setNextWordDuelGameState(int newScore) {
    GameState gameState = state.getCurrentGameState();

    if (gameState.hasRemainingWords) {
      var remainingWords = gameState.remainingWords;
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      state = createCheckWordDuelGameState(word, newScore, remainingWords, state);

      print("published newScore: $newScore.");
      var gameState1 = state.player1.gameState;
      var gameState2 = state.player2.gameState;
      print("remainingWords of Player1: ${gameState1.remainingWords.length}");
      print("remainingWords of Player2: ${gameState2.remainingWords.length}");
      print("score of Player1: ${gameState1.score}");
      print("score of Player2: ${gameState2.score}");
    } else {
      if (playingLastPlayerLastWord()) {
        print("State: playingLastPlayerLastWord.");
        // Playing last Player's last word. The next state will be FinishedGameState.
      } else {
        print("State: finishedDuelGameState.");
        state = createFinishedDuelGameState(newScore, state);
      }
    }
  }

  bool playingLastPlayerLastWord() =>
      state.isPlayer1 && !state.player2.gameState.hasRemainingWords;

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
