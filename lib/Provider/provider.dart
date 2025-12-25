import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../Service/api_service.dart';
import '../models/BotInfo.dart';
import '../models/message.dart';

class BotProvider with ChangeNotifier {
  BotInfo? _botInfo;
  List<MessageHistory> _messageHistory = [];
  bool _isLoading = false;
  String? _error;

  BotInfo? get botInfo => _botInfo;
  List<MessageHistory> get messageHistory => _messageHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBotInfo() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/api/bot/info');
      if (response['success']) {
        _botInfo = BotInfo.fromJson(response['data']);
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMessageHistory() async {
    try {
      final response = await ApiService.get('/api/messages/history');
      if (response['success']) {
        _messageHistory = (response['data']['messages'] as List)
            .map((m) => MessageHistory.fromJson(m))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    required String text,
    String? photoUrl,
    String? videoUrl,
  }) async {
    try {
      final data = {
        'chat_id': chatId,
        'text': text,
        'photo_url': photoUrl,
        'video_url': videoUrl,
        'parse_mode': 'HTML',
      };

      final response = await ApiService.post('/api/messages/send', data);
      await loadMessageHistory();
      return response;
    } catch (e) {
      throw Exception('Xabar yuborishda xatolik: $e');
    }
  }

  Future<Map<String, dynamic>> editMessage({
    required String chatId,
    required int messageId,
    required String text,
  }) async {
    try {
      final data = {
        'chat_id': chatId,
        'message_id': messageId,
        'text': text,
        'parse_mode': 'HTML',
      };

      final response = await ApiService.put('/api/messages/edit', data);
      await loadMessageHistory();
      return response;
    } catch (e) {
      throw Exception('Xabarni tahrirlashda xatolik: $e');
    }
  }

  Future<Map<String, dynamic>> deleteMessage({
    required String chatId,
    required int messageId,
  }) async {
    try {
      final data = {
        'chat_id': chatId,
        'message_id': messageId,
      };

      final response = await ApiService.delete('/api/messages/delete', data);
      await loadMessageHistory();
      return response;
    } catch (e) {
      throw Exception('Xabarni o\'chirishda xatolik: $e');
    }
  }
}