import '../data/data.dart';

GameState initGameState() =>
    GameState(word: null, score: 0, isFinished: false, remainingWords: []);

GameState startNewGameState(List<Word> remaining) => GameState(
    word: null,
    score: 0,
    isFinished: remaining.isEmpty,
    remainingWords: remaining);

GameState checkWordGameState(int newScore, List<Word> remaining) => GameState(
    word: null,
    score: newScore,
    isFinished: remaining.isEmpty,
    remainingWords: remaining);

GameState nextWordGameState(Word word, int newScore, List<Word> remaining) =>
    GameState(
        word: word,
        score: newScore,
        isFinished: remaining.isEmpty,
        remainingWords: remaining);
