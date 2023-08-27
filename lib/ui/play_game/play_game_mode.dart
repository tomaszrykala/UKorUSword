import '../../repo/words_repo.dart';

class PlayGameMode {
  final WordsRepository wordsRepository;
  final bool isSoloMode;
  final String p1Name;
  final String p2Name;

  PlayGameMode.solo({required this.wordsRepository})
      : isSoloMode = true,
        p1Name = "",
        p2Name = "";

  PlayGameMode.duel({required this.wordsRepository, required this.p1Name, required this.p2Name}) : isSoloMode = false;
}
