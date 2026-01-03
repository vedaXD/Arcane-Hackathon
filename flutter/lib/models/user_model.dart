class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // 'driver', 'passenger', 'admin'
  final String? phoneNumber;
  final String? gender;
  final String? profilePicture;
  final double trustScore;
  final int totalRides;
  final double totalCo2Saved;
  final int rewardPoints;
  final bool isVerified;
  final int? organizationId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.phoneNumber,
    this.gender,
    this.profilePicture,
    required this.trustScore,
    required this.totalRides,
    required this.totalCo2Saved,
    required this.rewardPoints,
    required this.isVerified,
    this.organizationId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? 'passenger',
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      profilePicture: json['profile_picture'],
      trustScore: double.parse(json['trust_score']?.toString() ?? '5.0'),
      totalRides: json['total_rides'] ?? 0,
      totalCo2Saved: double.parse(json['total_co2_saved']?.toString() ?? '0.0'),
      rewardPoints: json['reward_points'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      organizationId: json['organization'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'phone_number': phoneNumber,
      'gender': gender,
      'profile_picture': profilePicture,
      'trust_score': trustScore,
      'total_rides': totalRides,
      'total_co2_saved': totalCo2Saved,
      'reward_points': rewardPoints,
      'is_verified': isVerified,
      'organization': organizationId,
    };
  }

  String get fullName => '$firstName $lastName'.trim();
}
