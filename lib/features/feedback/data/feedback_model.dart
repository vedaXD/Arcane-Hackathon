// Feedback model
class FeedbackModel {
  final String id;
  final String userId;
  final String tripId;
  final int rating;
  final String comment;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.rating,
    required this.comment,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      tripId: json['tripId'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tripId': tripId,
      'rating': rating,
      'comment': comment,
    };
  }
}
