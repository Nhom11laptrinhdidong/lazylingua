import 'dart:math';
import 'package:flutter/material.dart';
import '../model/quiz_question.dart';
import 'steak_manager.dart';

class QuizViewModel extends ChangeNotifier {
  final List<dynamic> allWords;
  late QuizQuestion currentQuestion;
  String? selectedOption;
  bool showResult = false;

  final StreakManager streakManager = StreakManager();
  int currentStreak = 0;
  int highestStreak = 0;

  QuizViewModel(this.allWords) {
    _init();
  }

  Future<void> _init() async {
    await streakManager.loadStreak();
    currentStreak = streakManager.currentStreak;
    highestStreak = streakManager.highestStreak;
    generateQuestion();
    notifyListeners();
  }

  void generateQuestion() {
    final filtered = allWords.where((w) => w['senses'] != null && w['senses'].isNotEmpty).toList();
    if (filtered.length < 4) return;
    final rnd = Random();
    final correct = filtered[rnd.nextInt(filtered.length)];
    final ans = correct['word'];
    final def = correct['senses'][rnd.nextInt(correct['senses'].length)]['definition'];
    final wrongs = <String>{};
    while (wrongs.length < 3) {
      final w = filtered[rnd.nextInt(filtered.length)]['word'];
      if (w != ans) wrongs.add(w);
    }

    currentQuestion = QuizQuestion(
      definition: def,
      correctAnswer: ans,
      options: ([ans, ...wrongs]..shuffle()),
    );
    selectedOption = null;
    showResult = false;
    notifyListeners();
  }

  void checkAnswer(String answer) {
    selectedOption = answer;
    showResult = true;
    if (answer == currentQuestion.correctAnswer) {
      currentStreak++;
      streakManager.saveCurrentStreak(currentStreak);
      if (currentStreak > highestStreak) {
        highestStreak = currentStreak;
        streakManager.saveHighestStreak(highestStreak);
      }
    } else {
      currentStreak = 0;
    }
    notifyListeners();
  }

  Color getStreakFlameColor() {
    if (currentStreak < 10) return Colors.orange;
    if (currentStreak < 20) return Colors.red;
    if (currentStreak < 30) return Colors.blue;
    if (currentStreak < 40) return Colors.green;
    if (currentStreak < 50) return Colors.purpleAccent.shade700;
    return Colors.purple.shade900;
  }

  String getStreakText() {
    if (currentStreak < 10) return "🔥 Streak: $currentStreak";
    if (currentStreak < 20) return "🔥🔥 Hot streak: $currentStreak";
    if (currentStreak < 30) return "🔥🔥🔥 Super streak: $currentStreak";
    if (currentStreak < 40) return "🔥🔥🔥🔥 Ultra streak: $currentStreak";
    if (currentStreak < 50) return "🔥🔥🔥🔥🔥 Mega streak: $currentStreak";
    return "🔥🔥🔥🔥🔥🔥 LEGENDARY: $currentStreak";
  }
}