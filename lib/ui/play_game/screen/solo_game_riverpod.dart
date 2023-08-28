import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles.dart';
import '../../../domain/controller/solo_game_controller.dart';
import '../../../data/data.dart';

class SoloPlayGameRiverpod extends ConsumerWidget {
  SoloPlayGameRiverpod({super.key, required this.title})
      : _controller = SoloGameController.init();

  final String title;
  final SoloGameController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = _controller.stateProvider;
    final SoloGameController notifier = ref.read(provider.notifier);
    final SoloGameState state = ref.watch(provider);
    final GameState gameState = state.player.gameState;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor(context),
          title: Text(title),
        ),
        body: Center(child: _buildContentColumn(gameState, notifier, context)));
  }

  Column _buildContentColumn(
      GameState state, SoloGameController notifier, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTitleRow(state, context),
        _buildButtonsRow(state, notifier),
        _buildScoreRow(state, context),
        if (!state.finishedAllWords) _buildCountDownRow(state, context),
      ],
    );
  }

  Container _buildTitleRow(GameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Text(
        state.finishedAllWords ? 'Game Over' : 'The term is:\n`${state.word!.word}`',
        style: textLarge(context),
        textAlign: TextAlign.center,
      ));

  Row _buildButtonsRow(GameState state, SoloGameController notifier) {
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

  Container _buildScoreRow(GameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 24),
      child: Text(
        'Your score is: ${state.score}',
        style: textSmall(context),
      ));

  Container _buildCountDownRow(GameState state, BuildContext context) {
    var remaining = state.remainingWords;
    var text = remaining.isEmpty ? 'Last word!' : 'Remaining words: ${remaining.length}.';
    return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Text(text, style: textSmall(context)));
  }

  MaterialButton _buildMaterialButton(
          SoloGameController notifier, Word word, Locale locale) =>
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
