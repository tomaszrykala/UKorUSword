import '../data/data.dart';

// GameState
GameState createInitGameState() =>
    GameState(word: null, score: 0, remainingWords: []);

GameState createStartNewGameState(List<Word> remaining) =>
    GameState(word: null, score: 0, remainingWords: remaining);

GameState createCheckWordGameState(
        Word word, int newScore, List<Word> remaining) =>
    GameState(word: word, score: newScore, remainingWords: remaining);

GameState createFinishedGameState(int finalScore) =>
    GameState(word: null, score: finalScore, remainingWords: []);

// SoloGameState
SoloGameState createInitSoloGameState() => SoloGameState(
    player: DuelPlayer(name: "", gameState: createInitGameState()));

SoloGameState createStartNewSoloGameState(List<Word> remaining) =>
    SoloGameState(
        player: DuelPlayer(
            name: "", gameState: createStartNewGameState(remaining)));

SoloGameState createCheckWordSoloGameState(
        Word word, int newScore, List<Word> remaining) =>
    SoloGameState(
        player: DuelPlayer(
            name: "",
            gameState: createCheckWordGameState(word, newScore, remaining)));

SoloGameState createFinishedSoloGameState(int finalScore) => SoloGameState(
    player:
        DuelPlayer(name: "", gameState: createFinishedGameState(finalScore)));
