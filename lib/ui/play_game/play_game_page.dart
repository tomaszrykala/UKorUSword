import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../styles.dart';
import 'play_game_mode.dart';
import '../../domain/game_controller.dart';
import '../../data/data.dart';

class PlayGamePage extends StatelessWidget {
  const PlayGamePage(
      {super.key, required this.title, required this.playGameMode});

  final String title;
  final PlayGameMode playGameMode;

  @override
  Widget build(BuildContext context) => ProviderScope(
        child: _PlayGameRiverpod(title: title),
      );
}

class _PlayGameRiverpod extends ConsumerWidget {
  _PlayGameRiverpod({required this.title});

  final String title;
  final GameController _controller = GameController.init();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = _controller.stateProvider;
    final GameController notifier = ref.read(provider.notifier);
    final GameState state = ref.watch(provider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor(context),
          title: Text(title),
        ),
        body: Center(child: _buildContentColumn(state, notifier, context)));
  }

  Column _buildContentColumn(
      GameState state, GameController notifier, BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            state.finishedAllWords
                ? 'Game Over'
                : 'The term is:\n`${state.word!.word}`',
            style: textLarge(context),
            textAlign: TextAlign.center,
          )
        ],
      ));

  Row _buildButtonsRow(GameState state, GameController notifier) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Your score is: ${state.score}',
            style: textSmall(context),
          )
        ],
      ));

  Container _buildCountDownRow(GameState state, BuildContext context) {
    var remaining = state.remainingWords;
    var text = remaining.isEmpty
        ? 'Last word!'
        : 'Remaining words: ${remaining.length}.';
    return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Text(text, style: textSmall(context)));
  }

  MaterialButton _buildMaterialButton(
          GameController notifier, Word word, Locale locale) =>
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
