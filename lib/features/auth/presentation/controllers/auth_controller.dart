import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/errors/api_error_mapper.dart';
import '../../../../core/local_storage/local_storage_manager.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  static const tokenKey = 'api_authkey';

  @override
  FutureOr<AuthState> build() async {
    // Lecture du token au démarrage
    final token =
        await ref.read(localStorageManagerProvider).read(key: tokenKey);
    return AuthState(
      status:
          token != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    try {
      final token =
          await ref.read(authRepositoryProvider).login(username, password);
      await ref
          .read(localStorageManagerProvider)
          .write(key: tokenKey, value: token);
      state = const AsyncData(AuthState(status: AuthStatus.authenticated));
    } on ApiException catch (e) {
      _setError(ApiErrorMapper.getMessage(e.apiErrorCode));
    } catch (_) {
      _setError(ApiErrorMapper.getMessage(null));
    }
  }

  Future<void> logout() async {
    await ref.read(localStorageManagerProvider).delete(key: tokenKey);
    state = AsyncData(AuthState(status: AuthStatus.unauthenticated));
  }

  void _setError(String? message) {
    state = AsyncData(
      AuthState(status: AuthStatus.unauthenticated, errorMessage: message),
    );
  }
}