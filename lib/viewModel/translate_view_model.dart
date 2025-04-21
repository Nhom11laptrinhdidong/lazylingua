import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslateViewModel extends ChangeNotifier {
  final inputController = TextEditingController();
  String translatedText = '';
  bool isEnglishToVietnamese = true;

  final translator = GoogleTranslator();

  void toggleDirection() {
    isEnglishToVietnamese = !isEnglishToVietnamese;
    translatedText = '';
    inputController.clear();
    notifyListeners();
  }

  void clearInput() {
    inputController.clear();
    translatedText = '';
    notifyListeners();
  }

  Future<void> translateText() async {
    final input = inputController.text.trim();
    if (input.isEmpty) return;

    final from = isEnglishToVietnamese ? 'en' : 'vi';
    final to = isEnglishToVietnamese ? 'vi' : 'en';

    try {
      final result = await translator.translate(input, from: from, to: to);
      translatedText = result.text;
    } catch (e) {
      translatedText = 'Lỗi: $e';
    }

    notifyListeners();
  }
}
