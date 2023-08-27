import 'dart:math';

import '../../data/data.dart';
import '../../repo/words_repo.dart';

class GameWordsFactory {
  static const _wordsPerPlayer = 10;

  final WordsRepository wordsRepository;

  GameWordsFactory({required this.wordsRepository});

  List<List<Word>> getNewGameWords(int playerCount) {
    final allWords = wordsRepository.getAllWords();
    if (_wordsPerPlayer * playerCount > allWords.length) {
      throw ArgumentError("AllWords size must not exceed 10 unique words per player.");
    } else {
      List<int> unseenWordsIndices = [];
      List<List<Word>> newGameWords = [];
      for (int a = 0; a < playerCount; a++) {
        newGameWords.add([]);
      }

      for (int playerIndex = 0; playerIndex < playerCount; playerIndex++) {
        for (int wordIndex = 0; wordIndex < _wordsPerPlayer;) {
          int currentWordIndex = Random().nextInt(allWords.length);
          if (!unseenWordsIndices.contains(currentWordIndex)) {
            var unseenWord = allWords[currentWordIndex];
            newGameWords[playerIndex].add(unseenWord);
            unseenWordsIndices.add(currentWordIndex);
            wordIndex++;
          }
        }
      }
      return newGameWords;
    }
  }
}
