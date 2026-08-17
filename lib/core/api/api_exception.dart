class ApiException implements Exception {
  final String apiErrorCode;
  final int httpCode;

  ApiException(this.apiErrorCode, this.httpCode);

  @override
  String toString() => 'ApiException($httpCode): $apiErrorCode';
}