import 'dart:math';

import '../data/data.dart';
import 'game_state_factory.dart';

class GameController {
  final List<Word> _allWords = [];
  GameState _gameState = initGameState();

  GameController({required words}) {
    _allWords.addAll(words);
    _createGameWords();
  }

  void _createGameWords() {
    List<Word> gameWords = [];
    List<int> unseenWordsIndices = [];
    for (int i = 0; unseenWordsIndices.length < 11; i++) {
      int currentWordIndex = Random().nextInt(_allWords.length);
      if (!unseenWordsIndices.contains(currentWordIndex)) {
        var unseenWord = _allWords[currentWordIndex];
        gameWords.add(unseenWord);
        unseenWordsIndices.add(currentWordIndex);
      }
    }
    _gameState = startNewGameState(gameWords);
  }

  GameState checkGuess(Word word, Locale locale) {
    var newScore = word.locale == locale ? _gameState.score + 1 : 0;
    _gameState = checkWordGameState(newScore, _gameState.remainingWords);
    return _gameState;
  }

  GameState getGameState() {
    if (_gameState.remainingWords.isEmpty) {
      if (!_gameState.isFinished) {
        _setNewGameState();
      } else {
        _resetGameState();
      }
    } else {
      _setNextWordGameState();
    }
    return _gameState;
  }

  GameState onRestartGame() {
    _createGameWords();
    _setNewGameState();
    return _gameState;
  }

  void _setNewGameState() {
    setNextWordGameState(0);
  }

  void _setNextWordGameState() {
    setNextWordGameState(_gameState.score);
  }

  void _resetGameState() {
    _gameState = initGameState();
  }

  void setNextWordGameState(int newScore) {
    var remainingWords = _gameState.remainingWords; // TODO CSQ 10 -> 9?
    int index = Random().nextInt(remainingWords.length);
    Word word = remainingWords.removeAt(index);
    _gameState = nextWordGameState(word, newScore, remainingWords);
  }
}
