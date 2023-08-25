import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import '../../repo/words_repo.dart';
import '../game_state_factory.dart';
import '../new_game_words_factory.dart';

class DuelGameController extends StateNotifier<DuelGameState> {
  DuelGameController({required String p1Name, required String p2Name})
      : _p1Name = p1Name,
        _p2Name = p2Name,
        super(createInitDuelGameState(p1Name, p2Name));

  String _p1Name;
  String _p2Name;
  final List<Word> _allWords = [];
  final NewGameWordsFactory _newGameWordsFactory = NewGameWordsFactory();

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

    // check player guess
    state = createCheckWordDuelGameState(word, newScore, gameState.remainingWords, state);

    // change player
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
    } else {
      if (playingLastPlayerLastWord()) {
        // Playing last Player's last word. The next state will be FinishedGameState.
      } else {
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
    List<List<Word>> gameWords = _newGameWordsFactory.getNewGameWords(_allWords, 2);
    state = createStartNewDuelGameState(gameWords[0], gameWords[1], _p1Name, _p2Name);
    _publishDuelGameState();
  }
}
