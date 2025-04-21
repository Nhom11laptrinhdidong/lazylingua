import 'package:flutter/material.dart';
import '../model/wordRepository.dart';

class HomeViewModel extends ChangeNotifier {
  final WordRepository _repository = WordRepository();
  List<dynamic> words = [];

  bool isLoading = true;
  String? error;

  HomeViewModel() {
    fetchWords();
  }

  Future<void> fetchWords() async {
    try {
      words = await _repository.getAllWords();
      error = null;
    } catch (e) {
      error = 'Lỗi khi tải dữ liệu';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
