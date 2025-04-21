import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/chat_message.dart';
import '../viewModel/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> messages = [];
  final ChatService chatService;

  ChatViewModel({required this.chatService}) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('chat_history');
    if (jsonString != null) {
      final List<dynamic> data = jsonDecode(jsonString);
      messages.clear();
      messages.addAll(data.map((e) => ChatMessage.fromJson(e)).toList());
      notifyListeners();
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(messages.map((e) => e.toJson()).toList());
    await prefs.setString('chat_history', jsonString);
  }

  Future<void> sendMessage() async {
    final text = controller.text;
    if (text.isEmpty) return;

    messages.add(ChatMessage(role: 'user', text: text));
    controller.clear();
    notifyListeners();
    await _saveMessages();

    try {
      final response = await chatService.sendMessage(text);
      messages.add(ChatMessage(role: 'ai', text: response.trim()));
    } catch (e) {
      messages.add(ChatMessage(role: 'ai', text: 'Lỗi: $e'));
    }

    notifyListeners();
    await _saveMessages();
  }
}
