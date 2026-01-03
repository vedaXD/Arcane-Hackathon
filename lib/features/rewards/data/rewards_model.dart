// Rewards model
class RewardsModel {
  final String userId;
  final int points;
  final List<String> badges;

  RewardsModel({
    required this.userId,
    required this.points,
    required this.badges,
  });

  factory RewardsModel.fromJson(Map<String, dynamic> json) {
    return RewardsModel(
      userId: json['userId'] ?? '',
      points: json['points'] ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'points': points,
      'badges': badges,
    };
  }
}
