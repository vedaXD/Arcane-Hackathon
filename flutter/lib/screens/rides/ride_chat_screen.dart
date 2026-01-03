import 'package:flutter/material.dart';
import 'dart:async';

class RideChatScreen extends StatefulWidget {
  final int rideId;
  final List<Map<String, dynamic>> ridemates;

  const RideChatScreen({
    Key? key,
    required this.rideId,
    required this.ridemates,
  }) : super(key: key);

  @override
  State<RideChatScreen> createState() => _RideChatScreenState();
}

class _RideChatScreenState extends State<RideChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  Timer? _expiryTimer;
  Duration _timeRemaining = const Duration(hours: 24);

  @override
  void initState() {
    super.initState();
    _startExpiryTimer();
    _loadMessages();
  }

  void _startExpiryTimer() {
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining.inSeconds > 0) {
        setState(() {
          _timeRemaining = Duration(seconds: _timeRemaining.inSeconds - 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _loadMessages() {
    // TODO: Load from API
    // Mock messages for demonstration
    setState(() {
      _messages.addAll([
        {
          'id': 1,
          'sender': 'John',
          'message': 'Hey everyone! Looking forward to the ride 🚗',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'isMe': false,
        },
        {
          'id': 2,
          'sender': 'Me',
          'message': 'Hi! What time are we meeting?',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 25)),
          'isMe': true,
        },
      ]);
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      'id': _messages.length + 1,
      'sender': 'Me',
      'message': _messageController.text.trim(),
      'timestamp': DateTime.now(),
      'isMe': true,
    };

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // TODO: Send to API
  }

  String _formatTimeRemaining() {
    final hours = _timeRemaining.inHours;
    final minutes = _timeRemaining.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m remaining';
    }
    return '${minutes}m remaining';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ride Chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.ridemates.length} ride-mates',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showChatInfo(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Timer Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade400],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Chat expires in ${_formatTimeRemaining()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Ride-mates List
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border(bottom: BorderSide(color: Colors.green.shade200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ride-mates:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.ridemates.map((mate) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green.shade300,
                            child: Text(
                              mate['name'][0].toUpperCase(),
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            mate['name'],
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start the conversation!',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),

          // Message Input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Text(
                  message['sender'],
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.green : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
              ),
              child: Text(
                message['message'],
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                _formatTimestamp(message['timestamp']),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.info, color: Colors.green),
            SizedBox(width: 12),
            Text('Temporary Chat'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '🔒 Privacy Protected',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• No phone numbers shared'),
            Text('• Messages auto-delete after 24 hours'),
            Text('• Available only during ride period'),
            SizedBox(height: 16),
            Text(
              '💬 Use this chat to:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Coordinate pickup location'),
            Text('• Share arrival time updates'),
            Text('• Discuss ride details'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
