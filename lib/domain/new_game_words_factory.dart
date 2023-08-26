import 'dart:math';

import '../data/data.dart';

class NewGameWordsFactory {
  final _wordsPerPlayer = 10;

  List<List<Word>> getNewGameWords(List<Word> allWords, int playerCount) {
    if (_wordsPerPlayer * playerCount > allWords.length) {
      throw ArgumentError("allWords count exceeds 10 unique words per player sum.");
    } else {
      List<int> unseenWordsIndices = [];
      List<List<Word>> newGameWords = [];
      for (int a = 0; a < playerCount; a++) {
        newGameWords.add([]);
      }

      for (int playerIndex = 0; playerIndex < playerCount; playerIndex++) {
        for (int i = 0; i < _wordsPerPlayer; i++) {
          int currentWordIndex = Random().nextInt(allWords.length);
          if (!unseenWordsIndices.contains(currentWordIndex)) {
            var unseenWord = allWords[currentWordIndex];
            newGameWords[playerIndex].add(unseenWord);
            unseenWordsIndices.add(currentWordIndex);
          } else {
            i--;
          }
        }
      }

      return newGameWords;
    }
  }
}
