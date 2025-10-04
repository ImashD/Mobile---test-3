// lib/services/chatbot_service.dart
// 🌾 Wee Saviya Agricultural AI ChatBot Service
// Connects Flutter app to the mobile-optimized chatbot API

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ChatBotService {
  // Update this URL to your server's IP address when deploying
  static const String baseUrl = 'http://192.168.139.103:3000/api';
  static const uuid = Uuid();

  String? _sessionId;
  String get sessionId => _sessionId ??= uuid.v4();

  // Connection timeout settings
  static const Duration timeout = Duration(seconds: 30);

  /// Initialize chat session with user role and context
  Future<ChatResponse<bool>> initializeChat({
    String userRole = 'farmer',
    Map<String, dynamic>? userContext,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/chat/init'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'sessionId': sessionId,
              'userRole': userRole,
              'userContext': {
                'appVersion': '1.0.0',
                'platform': 'flutter',
                'userRole': userRole,
                'timestamp': DateTime.now().toIso8601String(),
                ...?userContext,
              },
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.success(data['success'] ?? false);
      } else {
        final error = jsonDecode(response.body);
        return ChatResponse.error('Failed to initialize: ${error['error']}');
      }
    } catch (e) {
      return ChatResponse.error('Connection error: ${e.toString()}');
    }
  }

  /// Send message to AI with optional context
  Future<ChatResponse<String>> sendMessage(
    String message, {
    Map<String, dynamic>? context,
  }) async {
    try {
      // Add agricultural context based on message content
      final enhancedContext = _enhanceContextForAgriculture(message, context);

      final response = await http
          .post(
            Uri.parse('$baseUrl/chat/message'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'sessionId': sessionId,
              'message': message,
              'context': enhancedContext,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.success(data['response'] ?? '');
      } else {
        final error = jsonDecode(response.body);
        return ChatResponse.error(error['error'] ?? 'Unknown error');
      }
    } catch (e) {
      return ChatResponse.error('Failed to send message: ${e.toString()}');
    }
  }

  /// Get chat session history
  Future<ChatResponse<Map<String, dynamic>>> getHistory() async {
    if (_sessionId == null) {
      return ChatResponse.error('No active session');
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/chat/history/$sessionId'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.success(data);
      } else {
        final error = jsonDecode(response.body);
        return ChatResponse.error(error['error'] ?? 'Failed to get history');
      }
    } catch (e) {
      return ChatResponse.error('Connection error: ${e.toString()}');
    }
  }

  /// End current chat session
  Future<ChatResponse<bool>> endSession() async {
    if (_sessionId == null) {
      return ChatResponse.success(true);
    }

    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/chat/$sessionId'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        _sessionId = null;
        return ChatResponse.success(true);
      } else {
        return ChatResponse.error('Failed to end session');
      }
    } catch (e) {
      return ChatResponse.error('Connection error: ${e.toString()}');
    }
  }

  /// Check server health
  Future<ChatResponse<Map<String, dynamic>>> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse.success(data);
      } else {
        return ChatResponse.error('Server health check failed');
      }
    } catch (e) {
      return ChatResponse.error('Server unavailable: ${e.toString()}');
    }
  }

  /// Enhance context with agricultural information
  Map<String, dynamic> _enhanceContextForAgriculture(
    String message,
    Map<String, dynamic>? baseContext,
  ) {
    final enhanced = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'messageLength': message.length,
      ...?baseContext,
    };

    // Detect agricultural keywords and add relevant context
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains(RegExp(r'\b(rice|paddy|samba|nadu)\b'))) {
      enhanced['topic'] = 'rice_cultivation';
      enhanced['cropType'] = _detectCropType(lowerMessage);
    }

    if (lowerMessage.contains(
      RegExp(r'\b(weather|rain|sunny|temperature)\b'),
    )) {
      enhanced['topic'] = 'weather';
      enhanced['needsWeatherData'] = true;
    }

    if (lowerMessage.contains(RegExp(r'\b(price|market|sell|buy)\b'))) {
      enhanced['topic'] = 'market';
      enhanced['needsPriceData'] = true;
    }

    if (lowerMessage.contains(
      RegExp(r'\b(disease|pest|problem|yellow|brown)\b'),
    )) {
      enhanced['topic'] = 'crop_health';
      enhanced['needsDiagnosis'] = true;
    }

    return enhanced;
  }

  /// Detect crop type from message
  String? _detectCropType(String message) {
    if (message.contains('samba')) return 'Samba';
    if (message.contains('nadu')) return 'Nadu';
    if (message.contains('keeri')) return 'Keeri Samba';
    return null;
  }

  /// Create new session with new ID
  void createNewSession() {
    _sessionId = uuid.v4();
  }
}

/// Response wrapper for API calls
class ChatResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ChatResponse.success(this.data) : error = null, isSuccess = true;
  ChatResponse.error(this.error) : data = null, isSuccess = false;
}

/// Message model for chat history
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;
  final String? messageId;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
    this.messageId,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'isError': isError,
    'messageId': messageId,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    text: json['text'],
    isUser: json['isUser'],
    timestamp: DateTime.parse(json['timestamp']),
    isError: json['isError'] ?? false,
    messageId: json['messageId'],
  );
}
