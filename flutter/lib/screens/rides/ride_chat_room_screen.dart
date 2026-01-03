import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme/app_theme.dart';
import '../payment/ride_payment_screen.dart';
import '../search/route_map_screen.dart';

class RideChatRoomScreen extends StatefulWidget {
  final String mode;
  final String pickup;
  final String dropoff;
  final String pickupLocation;
  final String dropoffLocation;
  final List<Map<String, dynamic>> ridemates;

  const RideChatRoomScreen({
    Key? key,
    required this.mode,
    required this.pickup,
    required this.dropoff,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.ridemates,
  }) : super(key: key);

  @override
  State<RideChatRoomScreen> createState() => _RideChatRoomScreenState();
}

class _RideChatRoomScreenState extends State<RideChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final Map<String, bool> _endRideVotes = {};
  bool _showEndRideVoting = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize votes for all ridemates
    for (var mate in widget.ridemates) {
      _endRideVotes[mate['name']] = false;
    }
    
    // Add welcome message
    _messages.add({
      'sender': 'System',
      'message': '🚗 Chat room created for 24 hours',
      'time': DateTime.now(),
      'isSystem': true,
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'sender': 'You',
        'message': _messageController.text,
        'time': DateTime.now(),
        'isSystem': false,
      });
      _messageController.clear();
    });
  }

  void _toggleEndRideVote(String name) {
    setState(() {
      _endRideVotes[name] = !_endRideVotes[name]!;
      _checkIfAllVoted();
    });
  }

  void _checkIfAllVoted() {
    // Check if all ridemates have voted
    int votesCount = _endRideVotes.values.where((v) => v == true).length;
    int totalRiders = widget.ridemates.length + 1; // +1 for current user
    
    // If majority voted (more than 50%), end the ride
    if (votesCount >= (totalRiders / 2).ceil()) {
      _endRide();
    }
  }

  void _initiateEndRideVoting() {
    setState(() {
      _showEndRideVoting = true;
      _endRideVotes['You'] = true; // Current user voted
      
      // Auto-vote for all other ridemates (simulating their agreement)
      for (var mate in widget.ridemates) {
        _endRideVotes[mate['name']] = true;
      }
      
      _messages.add({
        'sender': 'System',
        'message': '🏁 All riders agreed to end the ride!',
        'time': DateTime.now(),
        'isSystem': true,
      });
    });
    
    // Since everyone voted, end ride immediately
    Future.delayed(Duration(milliseconds: 500), () {
      _endRide();
    });
  }

  void _endRide() {
    // Calculate total distance and price
    double distance = 5.2; // Mock distance
    double co2Saved = 2.5; // Mock CO2
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RidePaymentScreen(
          ridemates: widget.ridemates,
          distance: distance,
          co2Saved: co2Saved,
          mode: widget.mode,
          pickupLocation: widget.pickupLocation,
          dropoffLocation: widget.dropoffLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ride Chat', style: TextStyle(fontSize: 18)),
            Text(
              '${widget.ridemates.length + 1} riders',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          // SOS Button
          IconButton(
            icon: Icon(Icons.warning, color: Colors.red),
            onPressed: () {
              _showSOSDialog();
            },
          ),
          if (!_showEndRideVoting)
            IconButton(
              icon: Icon(Icons.stop_circle_outlined),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('End Ride?'),
                    content: Text('Do you want to initiate a vote to end this ride?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _initiateEndRideVoting();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text('Yes, End Ride'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Ride info banner
          FadeInDown(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade100, Colors.green.shade100],
                ),
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.pickup} → ${widget.dropoff}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Voting status (if active)
          if (_showEndRideVoting)
            FadeIn(
              child: Container(
                padding: EdgeInsets.all(12),
                color: Colors.red.shade50,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.how_to_vote, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'End Ride Voting',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                        Text(
                          '${_endRideVotes.values.where((v) => v).length}/${widget.ridemates.length + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildVoteChip('You', true),
                        ...widget.ridemates.map((mate) => 
                          _buildVoteChip(mate['name'], _endRideVotes[mate['name']] ?? false)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Floating map button
      floatingActionButton: FadeInUp(
        delay: Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(0.8),
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero,
                child: RouteMapScreen(),
              ),
            );
          },
          backgroundColor: AppTheme.ecoGreen,
          child: Icon(Icons.map, size: 28),
        ),
      ),
    );
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 32),
            SizedBox(width: 12),
            Text(
              'Emergency SOS',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This will immediately notify:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.business, color: Colors.red.shade700, size: 18),
                      SizedBox(width: 8),
                      Expanded(child: Text('Organization Security Team', style: TextStyle(fontWeight: FontWeight.w500))),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.family_restroom, color: Colors.red.shade700, size: 18),
                      SizedBox(width: 8),
                      Expanded(child: Text('Your Emergency Contact', style: TextStyle(fontWeight: FontWeight.w500))),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red.shade700, size: 18),
                      SizedBox(width: 8),
                      Expanded(child: Text('Current ride location & details', style: TextStyle(fontWeight: FontWeight.w500))),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Only use in genuine emergencies',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _triggerSOS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Send SOS Alert'),
          ),
        ],
      ),
    );
  }

  void _triggerSOS() {
    // Mock SOS functionality
    setState(() {
      _messages.add({
        'sender': 'System',
        'message': '🚨 SOS Alert Triggered!\n\nNotifying:\n• Organization Security Team\n• Emergency Contact\n• Local Authorities\n\nStay safe! Help is on the way.',
        'time': DateTime.now(),
        'isSystem': true,
      });
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text('SOS Alert sent! Authorities & emergency contact notified.'),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Mock notifications (in real app, this would make API calls)
    _sendSOSNotifications();
  }

  void _sendSOSNotifications() {
    // Mock function - in real app would send notifications via API
    print('📱 SMS sent to emergency contact: Emergency alert from ${widget.pickup} to ${widget.dropoff}');
    print('🏢 Organization security notified with ride details and location');
    print('📧 Email alert sent to organization authorities');
  }

  Widget _buildVoteChip(String name, bool voted) {
    return Chip(
      avatar: Icon(
        voted ? Icons.check_circle : Icons.circle_outlined,
        color: voted ? Colors.green : Colors.grey,
        size: 18,
      ),
      label: Text(
        name,
        style: TextStyle(fontSize: 12),
      ),
      backgroundColor: voted ? Colors.green.shade50 : Colors.grey.shade100,
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isSystem = message['isSystem'] ?? false;
    bool isMe = message['sender'] == 'You';
    
    if (isSystem) {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message['message'],
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.orange : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                message['sender'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            Text(
              message['message'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
