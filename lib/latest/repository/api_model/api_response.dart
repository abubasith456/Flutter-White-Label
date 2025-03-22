class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data; // Make the data field nullable

  ApiResponse({
    required this.success,
    required this.message,
    this.data, // Nullable data field
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'],
      message: json['message'],
      data:
          json['data'] != null
              ? fromJsonT(json['data'])
              : null, // Handle null data
    );
  }
}
