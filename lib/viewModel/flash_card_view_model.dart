import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/flash_card_model.dart';
import '../viewModel/bookmark.dart';

class FlashCardViewModel extends ChangeNotifier {
  FlashCardModel model;
  bool showAnswer = false;

  FlashCardViewModel(List<dynamic> words) : model = FlashCardModel(words);

  void toggleAnswer() {
    showAnswer = !showAnswer;
    notifyListeners();
  }


  void pickNextWord() {
    model.pickRandomWord();
    showAnswer = false;
    notifyListeners();
  }

  bool isBookmarked(BuildContext context) {
    return context.watch<BookmarkManager>().isBookmarked(model.currentWord['word']);
  }

  void toggleBookmark(BuildContext context) {
    context.read<BookmarkManager>().toggleBookmark(model.currentWord);
    notifyListeners();
  }
}
