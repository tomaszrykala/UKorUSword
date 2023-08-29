import '../../data/data.dart';

// SoloGameState
SoloGameState createInitSoloGameState() =>
    SoloGameState(player: Player(name: "", gameState: _initGameState()));

SoloGameState createStartNewSoloGameState(List<Word> remaining) =>
    SoloGameState(player: Player(name: "", gameState: _startNewGameState(remaining)));

SoloGameState createCheckWordSoloGameState(
        Word word, int newScore, List<Word> remaining) =>
    SoloGameState(
        player:
            Player(name: "", gameState: _checkWordGameState(word, newScore, remaining)));

SoloGameState createFinishedSoloGameState(SoloGameState state) =>
    SoloGameState(player: Player.finished(state.player));

// DuelGameState
DuelGameState createInitDuelGameState(String p1Name, String p2Name) => DuelGameState.init(
      player1: Player(name: p1Name, gameState: _initGameState()),
      player2: Player(name: p2Name, gameState: _initGameState()),
    );

DuelGameState createStartNewDuelGameState(
        List<Word> p1Words, List<Word> p2Words, String p1Name, String p2Name) =>
    DuelGameState.init(
        player1: Player(name: p1Name, gameState: _startNewGameState(p1Words)),
        player2: Player(name: p2Name, gameState: _startNewGameState(p2Words)));

DuelGameState createCheckWordDuelGameState(
    Word word, int newScore, List<Word> remaining, DuelGameState state) {
  if (state.isPlayer1Active) {
    var activePlayer = Player(
        name: state.player1NameLabel,
        gameState: _checkWordGameState(word, newScore, remaining));
    return DuelGameState(
        player1: activePlayer, player2: state.player2, activePlayer: activePlayer);
  } else {
    var activePlayer = Player(
        name: state.player2NameLabel,
        gameState: _checkWordGameState(word, newScore, remaining));
    return DuelGameState(
        player1: state.player1, player2: activePlayer, activePlayer: activePlayer);
  }
}

DuelGameState createFinishedDuelGameState(DuelGameState state, Winner winner) =>
    DuelGameState.finished(
        player1: Player.finished(state.player1),
        player2: Player.finished(state.player2),
        winner: winner);

// GameState
GameState _initGameState() => GameState(word: null, score: 0, remainingWords: []);

GameState _startNewGameState(List<Word> remaining) =>
    GameState(word: null, score: 0, remainingWords: remaining);

GameState _checkWordGameState(Word word, int newScore, List<Word> remaining) =>
    GameState(word: word, score: newScore, remainingWords: remaining);
