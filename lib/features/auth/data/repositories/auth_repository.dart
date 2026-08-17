import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/dio_provider.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(dioProvider));
}

class AuthRepository {
  AuthRepository(this._dio);
  final Dio _dio;

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post('/user/login', data: {
        'username': username,
        'password': password,
      });
      return response.data['token'] as String;
    } on DioException catch (e) {
      if (e.error is ApiException) throw e.error as ApiException;
      throw ApiException('generic_error', e.response?.statusCode ?? 500);
    }
  }
}