import '../data/data.dart';

GameState initGameState() => GameState(
    currentWord: null, currentScore: 0, isFinished: false, remainingWords: []);

GameState startNewGameState(List<Word> remaining) => GameState(
    currentWord: null,
    currentScore: 0,
    isFinished: remaining.isEmpty,
    remainingWords: remaining);

GameState checkWordGameState(int newScore, List<Word> remaining) => GameState(
    currentWord: null,
    currentScore: newScore,
    isFinished: remaining.isEmpty,
    remainingWords: remaining);

GameState nextWordGameState(Word word, int newScore, List<Word> remaining) =>
    GameState(
        currentWord: word,
        currentScore: newScore,
        isFinished: remaining.isEmpty,
        remainingWords: remaining);

GameState finishedGameState(int currentScore) => GameState(
    currentWord: null,
    currentScore: currentScore,
    isFinished: true,
    remainingWords: []);
