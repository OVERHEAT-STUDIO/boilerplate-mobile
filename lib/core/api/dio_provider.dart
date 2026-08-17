import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../config/app_config.dart';
import '../local_storage/local_storage_manager.dart';
import 'api_exception.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final storage = ref.watch(localStorageManagerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // 1. Logger (debug only)
  if (kDebugMode) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint(
            '[API] --> ${options.method} ${options.uri}',
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('[API] <-- ${response.statusCode}');
          handler.next(response);
        },
        onError: (e, handler) {
          debugPrint('[API] ERR ${e.response?.statusCode} — ${e.message}');
          handler.next(e);
        },
      ),
    );
  }

  // 2. Auth + Headers
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.read(key: AuthController.tokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['X-App-Token'] = const String.fromEnvironment(
          'API_APP_TOKEN',
          defaultValue: '',
        );
        options.headers['User-Agent'] = 'MyApp/1.0.0';
        options.headers['Cache-Control'] = 'no-cache';
        options.headers['Pragma'] = 'no-cache';
        handler.next(options);
      },
    ),
  );

  // 3. Error mapping (réponse API custom)
  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (response, handler) {
        final body = response.data;
        if (body is Map<String, dynamic>) {
          final apiMap = body['api'] as Map<String, dynamic>?;
          final code = apiMap?['code'] as int? ?? response.statusCode ?? 500;
          if (code >= 400) {
            final errorCode =
                apiMap?['error'] as String? ?? 'generic_error';
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                error: ApiException(errorCode, code),
              ),
            );
          }
        }
        handler.next(response);
      },
    ),
  );

  return dio;
}