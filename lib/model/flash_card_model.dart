import 'dart:math';

class FlashCardModel {
  List<dynamic> allWords = [];
  dynamic currentWord;

  FlashCardModel(List<dynamic> words) {
    allWords = words
        .where((word) => word['senses'] != null && word['senses'].isNotEmpty)
        .toList();
  }

  void pickRandomWord() {
    if (allWords.isNotEmpty) {
      currentWord = allWords[Random().nextInt(allWords.length)];
    }
  }
}
