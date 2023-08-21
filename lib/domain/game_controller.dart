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
    _gameState = checkWordGameState(newScore, _gameState.remainingWords);
    return _gameState;
  }

  GameState getGameState() {
    if (_gameState.remainingWords.isEmpty) {
      if (!_gameState.isFinished) {
        setNextWordGameState(0);
      } else {
        _resetGameState();
      }
    } else {
      setNextWordGameState(_gameState.score);
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

  void setNextWordGameState(int newScore) {
    int index = Random().nextInt(_gameState.remainingWords.length);
    Word word = _gameState.remainingWords.removeAt(index);
    _gameState = nextWordGameState(word, newScore, _gameState.remainingWords);
  }

  List<Word> _getNewGameWords() {
    List<Word> gameWords = [];
    List<int> unseenWordsIndices = [];
    for (int i = 0; unseenWordsIndices.length <= 10; i++) {
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
