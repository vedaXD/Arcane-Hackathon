// Journey model
class JourneyModel {
  final String id;
  final String tripId;
  final String status;
  final DateTime startTime;

  JourneyModel({
    required this.id,
    required this.tripId,
    required this.status,
    required this.startTime,
  });

  factory JourneyModel.fromJson(Map<String, dynamic> json) {
    return JourneyModel(
      id: json['id'] ?? '',
      tripId: json['tripId'] ?? '',
      status: json['status'] ?? '',
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'status': status,
      'startTime': startTime.toIso8601String(),
    };
  }
}
