import '../../data/data.dart';

// SoloGameState
SoloGameState createInitSoloGameState() =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _initGameState()));

SoloGameState createStartNewSoloGameState(List<Word> remaining) =>
    SoloGameState(player: DuelPlayer(name: "", gameState: _startNewGameState(remaining)));

SoloGameState createCheckWordSoloGameState(
        Word word, int newScore, List<Word> remaining) =>
    SoloGameState(
        player: DuelPlayer(
            name: "", gameState: _checkWordGameState(word, newScore, remaining)));

SoloGameState createFinishedSoloGameState(int finalScore) => SoloGameState(
    player: DuelPlayer(name: "", gameState: _finishedGameState(finalScore)));

// DuelGameState
DuelGameState createInitDuelGameState(String p1Name, String p2Name) => DuelGameState(
      isPlayer1: true,
      player1: DuelPlayer(name: p1Name, gameState: _initGameState()),
      player2: DuelPlayer(name: p2Name, gameState: _initGameState()),
    );

DuelGameState createStartNewDuelGameState(
        List<Word> p1Words, List<Word> p2Words, String p1Name, String p2Name) =>
    DuelGameState(
        isPlayer1: true,
        player1: DuelPlayer(name: p1Name, gameState: _startNewGameState(p1Words)),
        player2: DuelPlayer(name: p2Name, gameState: _startNewGameState(p2Words)));

DuelGameState createCheckWordDuelGameState(
    Word word, int newScore, List<Word> remaining, DuelGameState state) {
  if (state.isPlayer1) {
    return DuelGameState(
      isPlayer1: true,
      player1: DuelPlayer(
          name: state.player1.name,
          gameState: _checkWordGameState(word, newScore, remaining)),
      player2: state.player2,
    );
  } else {
    return DuelGameState(
      isPlayer1: false,
      player1: state.player1,
      player2: DuelPlayer(
          name: state.player2.name,
          gameState: _checkWordGameState(word, newScore, remaining)),
    );
  }
}

DuelGameState createFinishedDuelGameState(int finalScore, DuelGameState state) {
  var player1 = state.player1;
  return DuelGameState(
      isPlayer1: false,
      player1: DuelPlayer(
          name: player1.name, gameState: _finishedGameState(player1.gameState.score)),
      player2: DuelPlayer(
          name: state.player2.name, gameState: _finishedGameState(finalScore)));
}

// GameState
GameState _initGameState() => GameState(word: null, score: 0, remainingWords: []);

GameState _startNewGameState(List<Word> remaining) =>
    GameState(word: null, score: 0, remainingWords: remaining);

GameState _checkWordGameState(Word word, int newScore, List<Word> remaining) =>
    GameState(word: word, score: newScore, remainingWords: remaining);

GameState _finishedGameState(int finalScore) =>
    GameState(word: null, score: finalScore, remainingWords: []);
