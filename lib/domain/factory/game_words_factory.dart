import 'dart:math';

import '../../data/data.dart';
import '../../repo/words_repo.dart';

class GameWordsFactory {
  static const _wordsPerPlayer = 10;

  final List<Word> _allWords = [];
  final WordsRepository wordsRepository;

  GameWordsFactory({required this.wordsRepository}) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Word> allWords = await wordsRepository.fetchAllWords();
    _allWords.addAll(allWords);
  }

  List<List<Word>> getNewGameWords(int playerCount) {
    if (_wordsPerPlayer * playerCount > _allWords.length) {
      throw ArgumentError("AllWords size must not exceed 10 unique words per player.");
    } else {
      List<int> unseenWordsIndices = [];
      List<List<Word>> newGameWords = [];
      for (int a = 0; a < playerCount; a++) {
        newGameWords.add([]);
      }

      for (int playerIndex = 0; playerIndex < playerCount; playerIndex++) {
        for (int wordIndex = 0; wordIndex < _wordsPerPlayer;) {
          int currentWordIndex = Random().nextInt(_allWords.length);
          if (!unseenWordsIndices.contains(currentWordIndex)) {
            var unseenWord = _allWords[currentWordIndex];
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
