import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class WordRepository {
  static final WordRepository _instance = WordRepository._internal();
  factory WordRepository() => _instance;

  WordRepository._internal();

  final List<dynamic> _cachedWords = [];

  Future<List<dynamic>> getAllWords() async {
    if (_cachedWords.isNotEmpty) return _cachedWords;

    List<String> files = List.generate(
      26,
          (index) => 'assets/Json/${String.fromCharCode(index + 97)}.json',
    );

    for (String file in files) {
      String data = await rootBundle.loadString(file);
      List<dynamic> words = jsonDecode(data);
      _cachedWords.addAll(words);
    }

    return _cachedWords;
  }

  void clearCache() {
    _cachedWords.clear();
  }
}