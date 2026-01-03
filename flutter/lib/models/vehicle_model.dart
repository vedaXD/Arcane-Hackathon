class Vehicle {
  final int id;
  final int driverId;
  final String? driverName;
  final String vehicleType;
  final String model;
  final String registrationNumber;
  final String fuelType; // 'petrol', 'diesel', 'electric', 'hybrid'
  final int capacity;
  final String color;
  final int year;
  final bool isVerified;
  final DateTime createdAt;

  Vehicle({
    required this.id,
    required this.driverId,
    this.driverName,
    required this.vehicleType,
    required this.model,
    required this.registrationNumber,
    required this.fuelType,
    required this.capacity,
    required this.color,
    required this.year,
    required this.isVerified,
    required this.createdAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      driverId: json['driver'],
      driverName: json['driver_name'],
      vehicleType: json['vehicle_type'],
      model: json['model'],
      registrationNumber: json['registration_number'],
      fuelType: json['fuel_type'],
      capacity: json['capacity'],
      color: json['color'],
      year: json['year'],
      isVerified: json['is_verified'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_type': vehicleType,
      'model': model,
      'registration_number': registrationNumber,
      'fuel_type': fuelType,
      'capacity': capacity,
      'color': color,
      'year': year,
    };
  }
}
