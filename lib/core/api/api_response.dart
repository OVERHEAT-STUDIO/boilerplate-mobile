class ApiResponse<T> {
  final int code;
  final String? error;
  final T? data;

  ApiResponse({required this.code, this.error, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?)? fromJsonT,
  ) {
    final apiMap = json['api'] as Map<String, dynamic>? ?? {};
    final dataMap = apiMap['data'] as Map<String, dynamic>?;
    return ApiResponse<T>(
      code: apiMap['code'] as int? ?? 500,
      error: apiMap['error'] as String?,
      data: (dataMap != null && fromJsonT != null) ? fromJsonT(dataMap) : null,
    );
  }

  bool get isSuccess => code >= 200 && code < 300;
}