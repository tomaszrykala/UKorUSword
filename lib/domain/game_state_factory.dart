import '../data/data.dart';

GameState createInitGameState() =>
    GameState(word: null, score: 0, remainingWords: []);

GameState createStartNewGameState(List<Word> remaining) =>
    GameState(word: null, score: 0, remainingWords: remaining);

GameState createCheckWordGameState(Word word, int newScore, List<Word> remaining) =>
    GameState(word: word, score: newScore, remainingWords: remaining);

GameState createFinishedGameState(int finalScore) =>
    GameState(word: null, score: finalScore, remainingWords: []);
