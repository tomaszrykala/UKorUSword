import '../data/data.dart';

// SoloGameState
SoloGameState createInitSoloGameState() =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _initGame()));

SoloGameState createStartNewSoloGameState(List<Word> remaining) =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _startNewGame(remaining)));

SoloGameState createCheckWordSoloGameState(Word word, int newScore, List<Word> remaining) =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _checkWord(word, newScore, remaining)));

SoloGameState createFinishedSoloGameState(int finalScore) =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _finishedGame(finalScore)));

// DuelGameState
DuelGameState createInitDuelGameState() => DuelGameState(
      player1: DuelPlayer(name: "", gameState: _initGame()),
      player2: DuelPlayer(name: "", gameState: _initGame()), // ensure words aren't repeated!
    );

// two remaining arguments
DuelGameState createStartNewDuelGameState(List<Word> remaining) => DuelGameState(
    player1: DuelPlayer(name: "", gameState: _startNewGame(remaining)),
    player2: DuelPlayer(name: "", gameState: _startNewGame(remaining)));

// which player?
DuelGameState createCheckWordDuelGameState(Word word, int newScore, List<Word> remaining) =>
    DuelGameState(
      player1: DuelPlayer(name: "", gameState: _checkWord(word, newScore, remaining)),
      player2: DuelPlayer(name: "", gameState: _checkWord(word, newScore, remaining)),
    );

// which player?
DuelGameState createFinishedDuelGameState(int finalScore) => DuelGameState(
      player1: DuelPlayer(name: "", gameState: _finishedGame(finalScore)),
      player2: DuelPlayer(name: "", gameState: _finishedGame(finalScore)),
    );

// GameState
GameState _initGame() => GameState(word: null, score: 0, remainingWords: []);

GameState _startNewGame(List<Word> remaining) =>
    GameState(word: null, score: 0, remainingWords: remaining);

GameState _checkWord(Word word, int newScore, List<Word> remaining) =>
    GameState(word: word, score: newScore, remainingWords: remaining);

GameState _finishedGame(int finalScore) =>
    GameState(word: null, score: finalScore, remainingWords: []);
