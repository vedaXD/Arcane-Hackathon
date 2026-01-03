// Common response model
class CommonResponseModel {
  final bool success;
  final String message;
  final dynamic data;

  CommonResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) {
    return CommonResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}
