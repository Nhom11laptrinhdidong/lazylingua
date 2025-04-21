class QuizQuestion {
  /// Định nghĩa (definition) của từ.
  final String definition;

  /// Đáp án đúng (correct answer) của câu hỏi.
  final String correctAnswer;

  /// Các lựa chọn (options) để người dùng chọn.
  final List<String> options;

  QuizQuestion({
    required this.definition,
    required this.correctAnswer,
    required this.options,
  });
}
