import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/word_game_state.dart';
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor(context),
          title: Text(title),
        ),
        body: Center(child: _buildContentColumn(state, notifier, context)));
  }

  Column _buildContentColumn(
          SoloGameState state, SoloGameController notifier, BuildContext context) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildTitleRow(state, context),
          _buildButtonsRow(state, notifier),
          _buildScoreRow(state, context),
          if (state.showCountDownRow) _buildCountDownRow(state, context),
        ],
      );

  Container _buildTitleRow(SoloGameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 24),
      child:
          Text(state.titleLabel, style: textLarge(context), textAlign: TextAlign.center));

  Row _buildButtonsRow(SoloGameState state, SoloGameController notifier) {
    const insets = 16.0;
    if (state.showGameFinishedState) {
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(insets),
              child: _buildMaterialButton(notifier, Locale.UK)),
          Container(
              margin: const EdgeInsets.all(insets),
              child: _buildMaterialButton(notifier, Locale.US))
        ],
      );
    }
  }

  Container _buildScoreRow(SoloGameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 24),
      child: Text(state.playerScoreLabel, style: textSmall(context)));

  Container _buildCountDownRow(SoloGameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 24),
      child: Text(state.playerRemainingLabel, style: textSmall(context)));

  MaterialButton _buildMaterialButton(SoloGameController notifier, Locale locale) =>
      MaterialButton(
        height: buttonHeight,
        color: locale == Locale.UK ? Colors.redAccent : Colors.lightBlueAccent,
        onPressed: () {
          notifier.onWordGuess(locale);
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
