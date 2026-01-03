// SOS model
class SosModel {
  final String id;
  final String userId;
  final String location;
  final DateTime timestamp;

  SosModel({
    required this.id,
    required this.userId,
    required this.location,
    required this.timestamp,
  });

  factory SosModel.fromJson(Map<String, dynamic> json) {
    return SosModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      location: json['location'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
