import 'package:flutter/material.dart';

class FeedbackDialog extends StatefulWidget {
  final String rideMateName;
  final Function(Map<String, dynamic>) onSubmit;

  const FeedbackDialog({
    Key? key,
    required this.rideMateName,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  int _overallRating = 5;
  int _punctualityRating = 5;
  int _behaviorRating = 5;
  int _cleanlinessRating = 5;
  int _communicationRating = 5;
  bool _wouldRideAgain = true;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.rate_review, color: Colors.green, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Rate ${widget.rideMateName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Your feedback helps improve matchmaking for future rides',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Divider(height: 24),
              
              // Overall Rating
              _buildRatingSection(
                'Overall Experience',
                _overallRating,
                (rating) => setState(() => _overallRating = rating),
              ),
              const SizedBox(height: 16),
              
              // Punctuality
              _buildRatingSection(
                'Punctuality ⏰',
                _punctualityRating,
                (rating) => setState(() => _punctualityRating = rating),
                subtitle: 'Was the person on time?',
              ),
              const SizedBox(height: 16),
              
              // Behavior
              _buildRatingSection(
                'Behavior 😊',
                _behaviorRating,
                (rating) => setState(() => _behaviorRating = rating),
                subtitle: 'How was their behavior?',
              ),
              const SizedBox(height: 16),
              
              // Cleanliness
              _buildRatingSection(
                'Cleanliness 🧼',
                _cleanlinessRating,
                (rating) => setState(() => _cleanlinessRating = rating),
                subtitle: 'How clean and hygienic?',
              ),
              const SizedBox(height: 16),
              
              // Communication
              _buildRatingSection(
                'Communication 💬',
                _communicationRating,
                (rating) => setState(() => _communicationRating = rating),
                subtitle: 'Communication quality',
              ),
              const SizedBox(height: 20),
              
              // Would Ride Again
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Would you ride with them again?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'This helps us match you better',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _wouldRideAgain,
                      onChanged: (value) => setState(() => _wouldRideAgain = value),
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Comment
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Additional Comments (Optional)',
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.comment),
                ),
              ),
              const SizedBox(height: 24),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Feedback',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection(
    String title,
    int rating,
    Function(int) onRatingChanged, {
    String? subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => onRatingChanged(index + 1),
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _submitFeedback() {
    final feedbackData = {
      'rating': _overallRating,
      'punctuality_rating': _punctualityRating,
      'behavior_rating': _behaviorRating,
      'cleanliness_rating': _cleanlinessRating,
      'communication_rating': _communicationRating,
      'would_ride_again': _wouldRideAgain,
      'comment': _commentController.text.trim(),
    };
    
    widget.onSubmit(feedbackData);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
