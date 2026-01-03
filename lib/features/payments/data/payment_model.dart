// Payment model
class PaymentModel {
  final String id;
  final String userId;
  final double amount;
  final String status;
  final DateTime timestamp;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
    required this.timestamp,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
