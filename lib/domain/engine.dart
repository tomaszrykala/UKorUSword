import 'dart:math';

import '../data/data.dart';

class GameController {
  final List<Word> _words = [];
  final List<Word> _gameWords = [];
  GameState _gameState = GameState(
      currentWord: null, currentScore: 0, isFinished: false, remainingWords: []);

  GameController({required words}) {
    _words.addAll(words);
    _createGameWords();
  }

  void _createGameWords() {
    List<int> unseenWordsIndices = [];
    for (int i = 0; unseenWordsIndices.length <= 10; i++) {
      int currentWordIndex = Random().nextInt(_words.length);
      if (!unseenWordsIndices.contains(currentWordIndex)) {
        var unseenWord = _words[currentWordIndex];
        _gameWords.add(unseenWord);
        unseenWordsIndices.add(currentWordIndex);
      }
    }
  }

  GameState checkGuess(Word word, Locale locale) {
    _gameState = GameState(
        currentWord: null,
        currentScore: word.locale == locale ? _gameState.currentScore + 1 : 0,
        isFinished: true,
        remainingWords: _gameWords);
    return _gameState;
  }

  GameState getGameState() {
    if (_gameState.wordCountDown == 0) {
      if (!_gameState.isFinished) {
        _setNewGameState();
      } else {
        _resetWords();
        _gameState = GameState(
            currentWord: null,
            currentScore: _gameState.currentScore,
            isFinished: true,
            remainingWords: _gameWords);
      }
    } else {
      if (_gameWords.isEmpty) {
        _gameState = GameState(
            currentWord: null,
            currentScore: _gameState.currentScore,
            isFinished: true,
            remainingWords: []);
      } else {
        _setNextWord(_gameState.currentScore);
      }
    }
    return _gameState;
  }

  GameState onRestartGame() {
    _resetWords();
    _createGameWords();
    _setNewGameState();
    return _gameState;
  }

  void _setNextWord(int newScore) {
    int index = Random().nextInt(_gameWords.length);
    Word word = _gameWords.removeAt(index);
    _gameState = GameState(
        currentWord: word,
        currentScore: newScore,
        isFinished: false,
        remainingWords: _gameWords);
  }

  void _setNewGameState() {
    _setNextWord(0);
  }

  void _resetWords() {
    _gameWords.clear();
  }
}