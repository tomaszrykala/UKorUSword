import 'dart:math';

import '../data/data.dart';
import 'game_state_factory.dart';

class GameController {
  final List<Word> _allWords = [];
  GameState _gameState = initGameState(); // observe..

  GameController({required words}) {
    _allWords.addAll(words);
    _createStartGameState();
  }

  void _createStartGameState() {
    _gameState = startNewGameState(_getNewGameWords());
  }

  GameState checkGuess(Word word, Locale locale) {
    var newScore = word.locale == locale ? _gameState.score + 1 : 0;
    _gameState = checkWordGameState(word, newScore, _gameState.remainingWords);
    return _gameState;
  }

  void _setNextWordGameState(int newScore) {
    var remainingWords = _gameState.remainingWords;
    if (remainingWords.isEmpty) {
      _gameState = finishedGameState(newScore);
    } else {
      int index = Random().nextInt(remainingWords.length);
      Word word = remainingWords.removeAt(index);
      _gameState = checkWordGameState(word, newScore, remainingWords);
    }
  }

  GameState getGameState() {
    if (_gameState.finishedLastWord) {
      if (!_gameState.isFinished) {
        _setNextWordGameState(0);
      } else {
        _resetGameState();
      }
    } else {
      _setNextWordGameState(_gameState.score);
    }
    return _gameState;
  }

  GameState getRestartGameState() {
    _createStartGameState();
    return _gameState;
  }

  void _resetGameState() {
    _gameState = initGameState();
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
