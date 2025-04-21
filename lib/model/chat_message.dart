class ChatMessage {
  final String role; // 'user' hoặc 'ai'
  final String text;

  ChatMessage({required this.role, required this.text});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'text': text,
    };
  }
}
