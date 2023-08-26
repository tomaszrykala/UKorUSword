import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles.dart';
import '../../../domain/solo_duel/duel_game_controller.dart';
import '../../../data/data.dart';

class DuelPlayGameRiverpod extends ConsumerWidget {
  DuelPlayGameRiverpod(
      {super.key, required this.title, required String p1Name, required p2Name})
      : _controller = DuelGameController.init(p1Name, p2Name);

  final String title;
  final DuelGameController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = _controller.stateProvider;
    final DuelGameController notifier = ref.read(provider.notifier);
    final DuelGameState state = ref.watch(provider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor(context),
          title: Text(title),
        ),
        body: Center(child: _buildContentColumn(state, notifier, context)));
  }

  Column _buildContentColumn(
      DuelGameState state, DuelGameController notifier, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTitleRow(state, context),
        _buildButtonsRow(state, notifier),
        _buildScoreRow(state, context),
        if (!state.finishedAllDuelWords()) _buildCountDownRow(state, context),
      ],
    );
  }

  Container _buildTitleRow(DuelGameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            state.finishedAllDuelWords()
                ? 'Game Over'
                : 'The term is:\n`${state.getCurrentGameState().word!.word}`',
            style: textLarge(context),
            textAlign: TextAlign.center,
          )
        ],
      ));

  Row _buildButtonsRow(DuelGameState state, DuelGameController notifier) {
    const insets = 16.0;
    if (state.finishedAllDuelWords()) {
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
      var word = state.getCurrentGameState().word!;
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

  Container _buildScoreRow(DuelGameState state, BuildContext context) {
    var playerName = state.getCurrentPlayer().name;
    var gameState = state.getCurrentGameState();
    return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$playerName\'s score is: ${gameState.score}',
              style: textSmall(context),
            )
          ],
        ));
  }

  Container _buildCountDownRow(DuelGameState state, BuildContext context) {
    var remaining = state.getCurrentGameState().remainingWords;
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
