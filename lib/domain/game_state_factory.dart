import '../data/data.dart';

GameState initGameState() =>
    GameState(word: null, score: 0, remainingWords: []);

GameState startNewGameState(List<Word> remaining) =>
    GameState(word: null, score: 0, remainingWords: remaining);

GameState checkWordGameState(Word word, int newScore, List<Word> remaining) =>
    GameState(word: word, score: newScore, remainingWords: remaining);

GameState finishedGameState(int finalScore) =>
    GameState(word: null, score: finalScore, remainingWords: []);
