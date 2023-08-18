import 'dart:math';

import '../repo/words_repo.dart';
import '../data/data.dart';

void checkGuess(
    Word word, Locale locale, Null Function() onGuess, Null Function() onFail) {
  if (word.locale == locale) {
    onGuess();
  } else {
    onFail();
  }
}

GameState getWord(List<Word> words) {
  Word? word = words.random();
  if (word == null) {
    return GameState(word: null, finished: true);
  } else {
    return GameState(word: word, finished: false);
  }
}

Future<List<Word>> getAllWords() => fetchAllWords();

extension UnseenWordRandomPick on List<Word> {
  Word? random() {
    var unseenWords = where((element) => !element.seen).toList();
    if (unseenWords.isNotEmpty) {
      int index = Random().nextInt(unseenWords.length);
      var word = unseenWords[index];
      firstWhere((element) => element == word).seen = true;
      return word;
    } else {
      return null;
    }
  }
}
