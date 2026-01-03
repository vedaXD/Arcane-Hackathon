class Trip {
  final int id;
  final int driverId;
  final String? driverName;
  final int vehicleId;
  final String? vehicleModel;
  final String startLocation;
  final double startLatitude;
  final double startLongitude;
  final String endLocation;
  final double endLatitude;
  final double endLongitude;
  final DateTime departureTime;
  final int availableSeats;
  final String genderPreference; // 'any', 'male', 'female'
  final double pricePerSeat;
  final String status; // 'scheduled', 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime updatedAt;

  Trip({
    required this.id,
    required this.driverId,
    this.driverName,
    required this.vehicleId,
    this.vehicleModel,
    required this.startLocation,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLocation,
    required this.endLatitude,
    required this.endLongitude,
    required this.departureTime,
    required this.availableSeats,
    required this.genderPreference,
    required this.pricePerSeat,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      driverId: json['driver'],
      driverName: json['driver_details']?['username'],
      vehicleId: json['vehicle'],
      vehicleModel: json['vehicle_details']?['model'],
      startLocation: json['start_location'],
      startLatitude: double.parse(json['start_latitude'].toString()),
      startLongitude: double.parse(json['start_longitude'].toString()),
      endLocation: json['end_location'],
      endLatitude: double.parse(json['end_latitude'].toString()),
      endLongitude: double.parse(json['end_longitude'].toString()),
      departureTime: DateTime.parse(json['departure_time']),
      availableSeats: json['available_seats'],
      genderPreference: json['gender_preference'] ?? 'any',
      pricePerSeat: double.parse(json['price_per_seat'].toString()),
      status: json['status'] ?? 'scheduled',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_location': startLocation,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'end_location': endLocation,
      'end_latitude': endLatitude,
      'end_longitude': endLongitude,
      'departure_time': departureTime.toIso8601String(),
      'available_seats': availableSeats,
      'gender_preference': genderPreference,
      'price_per_seat': pricePerSeat,
    };
  }
}
