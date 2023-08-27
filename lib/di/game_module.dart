import '../domain/factory/game_words_factory.dart';
import '../repo/words_repo.dart';

class GameModule {
  // instance
  static final GameModule _instance = GameModule._initInstance();

  static GameModule get instance => _instance;

  GameModule._initInstance();

  // WordsRepository Singleton
  late final WordsRepository _wordsRepository = WordsRepository();

  WordsRepository wordsRepository() => _wordsRepository;

  // GameWordsFactory Factory
  GameWordsFactory gameWordsFactory() =>
      GameWordsFactory(wordsRepository: wordsRepository());
}
