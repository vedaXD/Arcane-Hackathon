// Trip model
class TripModel {
  final String id;
  final String origin;
  final String destination;
  final DateTime departureTime;

  TripModel({
    required this.id,
    required this.origin,
    required this.destination,
    required this.departureTime,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      departureTime: DateTime.parse(json['departureTime'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime.toIso8601String(),
    };
  }
}
