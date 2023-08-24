import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles.dart';
import '../../../domain/solo_duel/duel_game_controller.dart';
import '../../../data/data.dart';

class DuelPlayGameRiverpod extends ConsumerWidget {
  DuelPlayGameRiverpod(
      {super.key, required this.title, required this.p1Name, required this.p2Name});

  final String title;
  final String p1Name;
  final String p2Name;
  final DuelGameController _controller =
      DuelGameController.init("Player 1", "Player 2"); // p1Name, p2Name

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = _controller.stateProvider;
    final DuelGameController notifier = ref.read(provider.notifier);
    final DuelGameState state = ref.watch(provider);
    final GameState gameState =
        state.isPlayer1 ? state.player1.gameState : state.player2.gameState;
    final playerName = state.isPlayer1 ? state.player1.name : state.player2.name;

    // if (state.isInitialised) {_controller.setNames(p1Name, p2Name);}

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor(context),
          title: Text(title),
        ),
        body:
            Center(child: _buildContentColumn(gameState, playerName, notifier, context)));
  }

  Column _buildContentColumn(GameState state, String playerName,
      DuelGameController notifier, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTitleRow(state, context),
        _buildButtonsRow(state, notifier),
        _buildScoreRow(state, playerName, context),
        if (!state.finishedAllWords) _buildCountDownRow(state, context),
      ],
    );
  }

  Container _buildTitleRow(GameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            state.finishedAllWords ? 'Game Over' : 'The term is:\n`${state.word!.word}`',
            style: textLarge(context),
            textAlign: TextAlign.center,
          )
        ],
      ));

  Row _buildButtonsRow(GameState state, DuelGameController notifier) {
    const insets = 16.0;
    if (state.finishedAllWords) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(insets),
              child: _buildMaterialOffButton(Locale.UK)),
          MaterialButton(
            height: buttonHeight,
            color: Colors.grey,
            onPressed: () {
              notifier.onRestartGameClicked();
            },
            child: const Text("Restart?"),
          ),
          Container(
              margin: const EdgeInsets.all(insets),
              child: _buildMaterialOffButton(Locale.US))
        ],
      );
    } else {
      var word = state.word!;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(insets),
              child: _buildMaterialButton(notifier, word, Locale.UK)),
          Container(
              margin: const EdgeInsets.all(insets),
              child: _buildMaterialButton(notifier, word, Locale.US))
        ],
      );
    }
  }

  Container _buildScoreRow(GameState state, String playerName, BuildContext context) =>
      Container(
          margin: const EdgeInsets.only(top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$playerName\'s score is: ${state.score}',
                style: textSmall(context),
              )
            ],
          ));

  Container _buildCountDownRow(GameState state, BuildContext context) {
    var remaining = state.remainingWords;
    var text = remaining.isEmpty ? 'Last word!' : 'Remaining words: ${remaining.length}.';
    return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Text(text, style: textSmall(context)));
  }

  MaterialButton _buildMaterialButton(
          DuelGameController notifier, Word word, Locale locale) =>
      MaterialButton(
        height: buttonHeight,
        color: locale == Locale.UK ? Colors.redAccent : Colors.lightBlueAccent,
        onPressed: () {
          notifier.onWordGuess(word, locale);
        },
        child: Text(locale.name),
      );

  MaterialButton _buildMaterialOffButton(Locale locale) => MaterialButton(
        height: buttonHeight,
        color: Colors.grey,
        onPressed: () {},
        child: Text(locale.name),
      );
}
