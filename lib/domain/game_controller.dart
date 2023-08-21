import 'dart:math';

import '../data/data.dart';
import 'game_state_factory.dart';

class GameController {
  final List<Word> _words = []; // TODO CSQ fetch from repo here
  GameState _gameState = initGameState();

  GameController({required words}) {
    _words.addAll(words);
    _createGameWords();
  }

  void _createGameWords() {
    List<Word> gameWords = [];
    List<int> unseenWordsIndices = [];
    for (int i = 0; unseenWordsIndices.length <= 10; i++) {
      int currentWordIndex = Random().nextInt(_words.length);
      if (!unseenWordsIndices.contains(currentWordIndex)) {
        var unseenWord = _words[currentWordIndex];
        gameWords.add(unseenWord);
        unseenWordsIndices.add(currentWordIndex);
      }
    }
    _gameState = startNewGameState(gameWords);
  }

  GameState checkGuess(Word word, Locale locale) {
    var newScore = word.locale == locale ? _gameState.currentScore + 1 : 0;
    _gameState = checkWordGameState(newScore, _gameState.remainingWords);
    return _gameState;
  }

  GameState getGameState() {
    if (_gameState.wordCountDown == 0) {
      if (!_gameState.isFinished) {
        _setNewGameState();
      } else {
        _resetGameState();
      }
    } else {
      if (_gameState.remainingWords.isEmpty) {
        _setFinishedGameState();
      } else {
        _setNextWordGameState();
      }
    }
    return _gameState;
  }

  GameState onRestartGame() {
    _createGameWords();
    _setNewGameState();
    return _gameState;
  }

  void _setNextWordGameState() {
    _gameState = _setNextWord(_gameState.currentScore);
  }

  void _setFinishedGameState() {
    _gameState = finishedGameState(_gameState.currentScore);
  }

  void _resetGameState() {
    _gameState = initGameState();
  }

  void _setNewGameState() {
    _gameState = _setNextWord(0);
  }

  GameState _setNextWord(int newScore) {
    var remainingWords = _gameState.remainingWords;
    int index = Random().nextInt(remainingWords.length);
    Word word = remainingWords.removeAt(index);
    return nextWordGameState(word, newScore, remainingWords);
  }
}
