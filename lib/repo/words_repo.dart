import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import '../data/data.dart';

Future<List<Word>> fetchAllWords() async {
  final rawData = await rootBundle.loadString("assets/words.csv");
  List<List<dynamic>> csvData =
      const CsvToListConverter(eol: ";", allowInvalid: false).convert(rawData);
  return mapAllWords(csvData);
}

List<Word> mapAllWords(List<List<dynamic>> csvData) {
  List<Word> allWords = [];
  for (var wordData in csvData) {
    if (wordData.length == 2) {
      var localeData = wordData[1];
      var locale = Locale.UK.name == localeData ? Locale.UK : Locale.US;
      var word = wordData[0].toString().replaceAll("\n", "");
      allWords.add(Word(word: word, locale: locale));
    }
  }
  return allWords;
}
