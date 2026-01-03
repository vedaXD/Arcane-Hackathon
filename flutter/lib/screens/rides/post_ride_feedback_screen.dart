import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme/app_theme.dart';

class PostRideFeedbackScreen extends StatefulWidget {
  final List<Map<String, dynamic>> ridemates;

  const PostRideFeedbackScreen({
    Key? key,
    required this.ridemates,
  }) : super(key: key);

  @override
  State<PostRideFeedbackScreen> createState() => _PostRideFeedbackScreenState();
}

class _PostRideFeedbackScreenState extends State<PostRideFeedbackScreen> {
  Map<String, int> ratings = {};
  Map<String, List<String>> selectedIssues = {};
  Map<String, bool> reported = {};
  
  final List<String> commonIssues = [
    'Late arrival',
    'Rude behavior',
    'Unsafe driving',
    'Cancelled last minute',
    'Wrong location',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize ratings for each ridemate
    for (var mate in widget.ridemates) {
      ratings[mate['name']] = 0;
      selectedIssues[mate['name']] = [];
      reported[mate['name']] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Your Experience'),
        backgroundColor: AppTheme.primaryOrange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.ecoGreen, AppTheme.ecoGreen.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.feedback, color: Colors.white, size: 48),
                    SizedBox(height: 12),
                    Text(
                      'Help Us Improve',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your feedback helps match you with better ride-mates',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Rate Your Ride-Mates',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...widget.ridemates.map((mate) => _buildRidemateFeedback(mate)).toList(),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit Feedback',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Skip for now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRidemateFeedback(Map<String, dynamic> mate) {
    final name = mate['name'];
    
    return FadeInUp(
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryOrange.withOpacity(0.2),
                  radius: 24,
                  child: Text(
                    mate['avatar'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '${mate['rating']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'How was your experience?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStarRating(name, 1),
                _buildStarRating(name, 2),
                _buildStarRating(name, 3),
                _buildStarRating(name, 4),
                _buildStarRating(name, 5),
              ],
            ),
            
            // Show report option if rating is low
            if (ratings[name] != null && ratings[name]! <= 2) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.report_problem, color: Colors.red[700], size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Report Issues',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: commonIssues.map((issue) {
                        final isSelected = selectedIssues[name]?.contains(issue) ?? false;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedIssues[name]?.remove(issue);
                              } else {
                                selectedIssues[name]?.add(issue);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.red[700] : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.red[700]! : Colors.red[300]!,
                              ),
                            ),
                            child: Text(
                              issue,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.red[700],
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 12),
                    CheckboxListTile(
                      value: reported[name] ?? false,
                      onChanged: (value) {
                        setState(() {
                          reported[name] = value ?? false;
                        });
                      },
                      title: Text(
                        'Report this user (will reduce match likelihood)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: Colors.red[700],
                    ),
                  ],
                ),
              ),
            ],
            
            // Show positive message if rating is high
            if (ratings[name] != null && ratings[name]! >= 4) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Great! We\'ll prioritize matching you again 🎉',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(String name, int starNumber) {
    final currentRating = ratings[name] ?? 0;
    final isSelected = starNumber <= currentRating;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          ratings[name] = starNumber;
        });
      },
      child: Icon(
        isSelected ? Icons.star : Icons.star_border,
        size: 36,
        color: isSelected ? Colors.amber : Colors.grey[400],
      ),
    );
  }

  void _submitFeedback() {
    // Check if all ridemates are rated
    bool allRated = true;
    for (var mate in widget.ridemates) {
      if ((ratings[mate['name']] ?? 0) == 0) {
        allRated = false;
        break;
      }
    }
    
    if (!allRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please rate all ride-mates'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Process feedback
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInDown(
              child: Icon(
                Icons.check_circle,
                color: AppTheme.ecoGreen,
                size: 64,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Thank You! 🙏',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Your feedback helps improve our matching algorithm',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '+50 💎',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                  Text(
                    'Bonus diamonds for feedback!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.ecoGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
