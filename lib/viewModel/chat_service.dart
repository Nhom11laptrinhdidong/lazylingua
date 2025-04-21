import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  final String apiKey;
  late final GenerativeModel model;

  ChatService(this.apiKey) {
    model = GenerativeModel(
      model: 'gemini-1.5-pro-001',  // ← đổi thành model bạn chọn
      apiKey: apiKey,
    );
  }

  Future<String> sendMessage(String message) async {
    try {
      final content = Content.text(message);
      final response = await model.generateContent([content]);
      return response.text ?? "Không có phản hồi từ AI.";
    } catch (e) {
      throw Exception("Lỗi Gemini: $e");
    }
  }
}
