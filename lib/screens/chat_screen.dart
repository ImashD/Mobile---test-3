// lib/screens/chat_screen.dart
// 🌾 Wee Saviya AI Assistant Chat Screen
// Agricultural AI assistant integrated with your farming app

import 'package:flutter/material.dart';
import '../services/chatbot_service.dart';

class ChatScreen extends StatefulWidget {
  final String userRole; // 'farmer', 'driver', or 'labor'
  final Map<String, dynamic>? initialContext;

  const ChatScreen({Key? key, this.userRole = 'farmer', this.initialContext})
    : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final ChatBotService _chatBot = ChatBotService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isTyping = false;
  String _connectionStatus = 'Connecting...';

  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    setState(() {
      _isLoading = true;
      _connectionStatus = 'Connecting to AI assistant...';
    });

    // Check server health first
    final healthResponse = await _chatBot.checkHealth();
    if (!healthResponse.isSuccess) {
      setState(() {
        _isLoading = false;
        _isInitialized = false;
        _connectionStatus = 'Server unavailable. Please check connection.';
      });
      return;
    }

    // Initialize chat session
    final response = await _chatBot.initializeChat(
      userRole: widget.userRole,
      userContext: {
        'initialContext': widget.initialContext,
        'userRole': widget.userRole,
        'appScreen': 'chat',
      },
    );

    setState(() {
      _isLoading = false;
      _isInitialized = response.isSuccess;
      _connectionStatus = response.isSuccess
          ? 'Connected to Sam - Agricultural Assistant'
          : response.error ?? 'Connection failed';
    });

    if (response.isSuccess) {
      _addMessage(
        ChatMessage(
          text: _getWelcomeMessage(),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  String _getWelcomeMessage() {
    switch (widget.userRole) {
      case 'farmer':
        return "🌾 Hello! I'm Sam, your agricultural assistant for Wee Saviya. I can help you with rice cultivation, market prices, weather planning, and connecting with drivers and laborers. What farming question can I help you with today?";
      case 'driver':
        return "🚚 Hello! I'm Sam, your assistant for Wee Saviya. I can help you with transportation requests, route planning, and connecting with farmers who need transport services. How can I assist you today?";
      case 'labor':
        return "👷 Hello! I'm Sam, your assistant for Wee Saviya. I can help you find work opportunities, skill development, and connect with farmers needing agricultural labor. What can I help you with?";
      default:
        return "👋 Hello! I'm Sam, your agricultural assistant for Wee Saviya. How can I help you today?";
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty || !_isInitialized) return;

    // Add user message immediately
    final userMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _addMessage(userMessage);

    _messageController.clear();
    _startTypingAnimation();

    // Get enhanced context based on current app state
    final context = _getCurrentAppContext();

    // Send to AI
    final response = await _chatBot.sendMessage(message, context: context);

    _stopTypingAnimation();

    if (response.isSuccess && response.data != null) {
      _addMessage(
        ChatMessage(
          text: response.data!,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } else {
      _addMessage(
        ChatMessage(
          text:
              "I'm having trouble connecting right now. Please check your internet connection and try again. Error: ${response.error}",
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
    }
  }

  void _startTypingAnimation() {
    setState(() => _isTyping = true);
  }

  void _stopTypingAnimation() {
    setState(() => _isTyping = false);
  }

  Map<String, dynamic> _getCurrentAppContext() {
    return {
      'currentScreen': 'chat',
      'userRole': widget.userRole,
      'timestamp': DateTime.now().toIso8601String(),
      'messageCount': _messages.length,
      'hasInitialContext': widget.initialContext != null,
      // Add current weather, location, or other app context here
      'appContext': widget.initialContext ?? {},
    };
  }

  void _addMessage(ChatMessage message) {
    setState(() => _messages.add(message));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _refreshConnection() async {
    await _initializeChat();
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat History'),
        content: Text('Are you sure you want to clear the chat history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              _chatBot.createNewSession();
              Navigator.of(context).pop();
              _initializeChat();
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sam - Agricultural Assistant",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              _connectionStatus,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF009688),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshConnection,
            tooltip: 'Refresh Connection',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  _clearChat();
                  break;
                case 'history':
                  _showChatHistory();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Clear Chat'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'history',
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Session Info'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status banner
          if (!_isInitialized && !_isLoading)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Colors.red[100],
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _connectionStatus,
                      style: TextStyle(color: Colors.red[800], fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: _refreshConnection,
                    child: Text('Retry', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),

          // Chat messages
          Expanded(
            child: _isInitialized
                ? ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isTyping && index == _messages.length) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  )
                : _buildConnectionView(),
          ),

          // Message input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _getHintText(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                    enabled: _isInitialized && !_isTyping,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isInitialized && !_isTyping
                      ? () => _sendMessage(_messageController.text)
                      : null,
                  mini: true,
                  backgroundColor: _isInitialized && !_isTyping
                      ? Color(0xFF009688)
                      : Colors.grey,
                  child: _isTyping
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getHintText() {
    switch (widget.userRole) {
      case 'farmer':
        return "Ask about crops, weather, markets, drivers...";
      case 'driver':
        return "Ask about transportation, routes, farmers...";
      case 'labor':
        return "Ask about jobs, skills, farmers...";
      default:
        return "Type your message...";
    }
  }

  Widget _buildConnectionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading) ...[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF009688)),
            ),
            SizedBox(height: 16),
            Text(
              _connectionStatus,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Unable to connect to AI assistant",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              _connectionStatus,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshConnection,
              icon: Icon(Icons.refresh),
              label: Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF009688),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF009688),
            child: Text(
              "S",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sam is thinking",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _typingAnimationController,
                  builder: (context, child) {
                    return Row(
                      children: List.generate(3, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[400]?.withOpacity(
                              (index * 0.33 +
                                      _typingAnimationController.value) %
                                  1.0,
                            ),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.isError ? Colors.red : Color(0xFF009688),
              child: Text(
                message.isError ? "!" : "S",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Color(0xFF009688)
                    : message.isError
                    ? Colors.red[50]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: message.isError
                    ? Border.all(color: Colors.red[200]!, width: 1)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white
                          : message.isError
                          ? Colors.red[800]
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: message.isUser ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF2196F3),
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showChatHistory() async {
    final response = await _chatBot.getHistory();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Session Information'),
        content: SingleChildScrollView(
          child: Text(
            response.isSuccess
                ? 'Session ID: ${_chatBot.sessionId}\n\nMessages: ${_messages.length}\n\nRole: ${widget.userRole}\n\nConnected: ${_isInitialized ? "Yes" : "No"}'
                : 'Error: ${response.error}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chatBot.endSession();
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }
}
