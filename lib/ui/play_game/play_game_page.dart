import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game_controller.dart';
import '../../data/data.dart';

class PlayGamePage extends StatelessWidget {
  const PlayGamePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: HomeRiverpod(title: title),
    );
  }
}

class HomeRiverpod extends ConsumerWidget {
  HomeRiverpod({super.key, required this.title});

  final String title;
  final GameController _controller = GameController.init();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = _controller.riverpodProvider;
    final GameController notifier = ref.read(provider.notifier);
    final GameState state = ref.watch(provider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Center(child: buildContentColumn(state, notifier, context)));
  }

  Column buildContentColumn(
      GameState state, GameController notifier, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildTitleRow(state, context),
        buildButtonsRow(state, notifier),
        buildScoreRow(state, context),
        if (!state.finishedAllWords) buildCountDownRow(state, context),
      ],
    );
  }

  Container buildTitleRow(GameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            state.finishedAllWords
                ? 'Game Over'
                : 'The term is:\n`${state.word!.word}`',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          )
        ],
      ));

  Row buildButtonsRow(GameState state, GameController notifier) {
    const insets = 16.0;
    if (state.finishedAllWords) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialOffButton(Locale.UK)),
          MaterialButton(
            height: 80,
            color: Colors.grey,
            onPressed: () {
              notifier.getRestartGameState();
            },
            child: const Text("Restart?"),
          ),
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialOffButton(Locale.US))
        ],
      );
    } else {
      var word = state.word!;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialButton(notifier, word, Locale.UK)),
          Container(
              margin: const EdgeInsets.all(insets),
              child: buildMaterialButton(notifier, word, Locale.US))
        ],
      );
    }
  }

  Container buildScoreRow(GameState state, BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Your score is: ${state.score}',
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ));

  Container buildCountDownRow(GameState state, BuildContext context) {
    var remaining = state.remainingWords;
    var text = remaining.isEmpty
        ? 'Last word!'
        : 'Remaining words: ${remaining.length}.';
    return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(text, style: Theme.of(context).textTheme.headlineSmall)
          ],
        ));
  }

  MaterialButton buildMaterialButton(
          GameController notifier, Word word, Locale locale) =>
      MaterialButton(
        height: 80,
        color: locale == Locale.UK ? Colors.redAccent : Colors.lightBlueAccent,
        onPressed: () {
          notifier.checkGuess(word, locale);
        },
        child: Text(locale.name),
      );

  MaterialButton buildMaterialOffButton(Locale locale) => MaterialButton(
        height: 80,
        color: Colors.grey,
        onPressed: () {},
        child: Text(locale.name),
      );
}
