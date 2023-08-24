import '../data/data.dart';

// SoloGameState
SoloGameState createInitSoloGameState() =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _initGame()));

SoloGameState createStartNewSoloGameState(List<Word> remaining) =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _startNewGame(remaining)));

SoloGameState createCheckWordSoloGameState(
        Word word, int newScore, List<Word> remaining) =>
    SoloGameState(
        player: DuelPlayer(name: "", gameState: _checkWord(word, newScore, remaining)));

SoloGameState createFinishedSoloGameState(int finalScore) =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _finishedGame(finalScore)));

// DuelGameState
DuelGameState createInitDuelGameState(String p1Name, String p2Name) => DuelGameState(
      isPlayer1: true,
      player1: DuelPlayer(name: p1Name, gameState: _initGame()),
      player2: DuelPlayer(
          name: p2Name, gameState: _initGame()), // ensure words aren't repeated!
    );

DuelGameState createStartNewDuelGameState(
        List<Word> p1Words, List<Word> p2Words, String p1Name, String p2Name) =>
    DuelGameState(
        isPlayer1: true,
        player1: DuelPlayer(name: p1Name, gameState: _startNewGame(p1Words)),
        player2: DuelPlayer(name: p2Name, gameState: _startNewGame(p2Words)));

DuelGameState createCheckWordDuelGameState(Word word, int newScore, List<Word> remaining,
    bool isPlayer1, DuelGameState duelGameState) {
  if (isPlayer1) {
    return DuelGameState(
      isPlayer1: true,
      player1: DuelPlayer(
          name: duelGameState.player1.name,
          gameState: _checkWord(word, newScore, remaining)),
      player2: duelGameState.player2,
    );
  } else {
    return DuelGameState(
      isPlayer1: false,
      player1: duelGameState.player1,
      player2: DuelPlayer(
          name: duelGameState.player2.name,
          gameState: _checkWord(word, newScore, remaining)),
    );
  }
}

DuelGameState createFinishedDuelGameState(
    int finalScore, bool isPlayer1, DuelGameState duelGameState) {
  if (isPlayer1) {
    return DuelGameState(
      isPlayer1: true,
      player1: DuelPlayer(
          name: duelGameState.player1.name, gameState: _finishedGame(finalScore)),
      player2: duelGameState.player2,
    );
  } else {
    return DuelGameState(
      isPlayer1: false,
      player1: duelGameState.player1,
      player2: DuelPlayer(
          name: duelGameState.player2.name, gameState: _finishedGame(finalScore)),
    );
  }
}

// GameState
GameState _initGame() => GameState(word: null, score: 0, remainingWords: []);

GameState _startNewGame(List<Word> remaining) =>
    GameState(word: null, score: 0, remainingWords: remaining);

GameState _checkWord(Word word, int newScore, List<Word> remaining) =>
    GameState(word: word, score: newScore, remainingWords: remaining);

GameState _finishedGame(int finalScore) =>
    GameState(word: null, score: finalScore, remainingWords: []);
