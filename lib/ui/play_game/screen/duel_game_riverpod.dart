import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles.dart';
import '../../../domain/controller/duel_game_controller.dart';
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
        _buildCurrentPlayerRow(state, context),
        _buildTitleRow(state, context),
        _buildButtonsRow(state, notifier),
        _buildNamesRow(state, context),
        _buildScoreRow(state, context),
        if (!state.finishedAllPlayerWords) _buildCountDownRow(state, context),
      ],
    );
  }

  Container _buildCurrentPlayerRow(DuelGameState state, BuildContext context) =>
      Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Text(
            '${state.activePlayer.name}\'s turn:',
            style: textMediumBold(context),
            textAlign: TextAlign.center,
          ));

  Container _buildTitleRow(DuelGameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Text(
        state.finishedAllPlayerWords
            ? 'Game Over'
            : 'The term is:\n`${state.activeGameState().word!.word}`',
        style: textLarge(context),
        textAlign: TextAlign.center,
      ));

  Row _buildButtonsRow(DuelGameState state, DuelGameController notifier) {
    const insets = 16.0;
    if (state.finishedAllPlayerWords) {
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
      var word = state.activeGameState().word!;
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

  Container _buildNamesRow(DuelGameState state, BuildContext context) {
    final bold = textMediumBold(context);
    final regular = textMedium(context);
    return Container(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(state.player1.name, style: state.isPlayer1 ? bold : regular),
            Text(state.player2.name, style: state.isPlayer1 ? regular : bold),
          ],
        ));
  }

  Container _buildScoreRow(DuelGameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('score -> ${state.player1.gameState.score}', style: textSmall(context)),
          Text('${state.player2.gameState.score} <- score', style: textSmall(context)),
        ],
      ));

  Container _buildCountDownRow(DuelGameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_remaining(state.player1, true), style: textSmall(context)),
          Text(_remaining(state.player2, false), style: textSmall(context)),
        ],
      ));

  String _remaining(Player player, bool isPlayer1) {
    final remaining = player.gameState.remainingWords;
    var length = remaining.length;
    var remainingLabel = isPlayer1 ? 'remaining [$length]' : '[$length] remaining';
    return remaining.isEmpty ? 'Last word!' : remainingLabel;
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
