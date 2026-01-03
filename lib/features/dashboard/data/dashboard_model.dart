// Dashboard model
class DashboardModel {
  final String userId;
  final int totalTrips;
  final double carbonSaved;

  DashboardModel({
    required this.userId,
    required this.totalTrips,
    required this.carbonSaved,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      userId: json['userId'] ?? '',
      totalTrips: json['totalTrips'] ?? 0,
      carbonSaved: (json['carbonSaved'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalTrips': totalTrips,
      'carbonSaved': carbonSaved,
    };
  }
}
