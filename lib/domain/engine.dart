import 'dart:math';

import '../repo/words_repo.dart';
import '../data/data.dart';

void checkGuess(Word word, List<Word> words, Locale locale,
    Null Function() onGuess, Null Function() onFail) {
  if (word.locale == locale) {
    onGuess();
  } else {
    resetWords(words);
    onFail();
  }
}

GameState getWord(List<Word> words, int wordsCountdown) {
  if (wordsCountdown == 0) {
    resetWords(words);
    return GameState(word: null, finished: true);
  } else {
    Word? word = words.random();
    if (word == null) {
      return GameState(word: null, finished: true);
    } else {
      return GameState(word: word, finished: false);
    }
  }
}

void restartGame(List<Word> words, Null Function() onRestart) {
  resetWords(words);
  onRestart();
}

void resetWords(List<Word> words) {
  for (var word in words) {
    word.seen = false;
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
