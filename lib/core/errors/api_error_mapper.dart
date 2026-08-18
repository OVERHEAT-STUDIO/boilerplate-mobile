import 'package:i18n/i18n.dart';

class ApiErrorMapper {
  ApiErrorMapper._();

  static String getMessage(String? errorCode) {
    final i18n = I18n.current;

    if (errorCode != null && errorCode.startsWith('API_RATE_LIMITED')) {
      return i18n.errorApiRateLimited;
    }

    switch (errorCode) {
      case 'generic_error':
        return i18n.errorApiGenericError;
      case 'rate_limited':
        return i18n.errorApiRateLimited;
      case 'forbidden':
        return i18n.errorApiForbidden;
      case 'invalid_token':
        return i18n.errorApiInvalidToken;
      case 'vpn_detected':
        return i18n.errorApiVpnDetected;
      case 'suspended_user':
        return i18n.errorApiSuspendedUser;
      default:
        return i18n.errorApiUnknown(errorCode ?? 'unknown');
    }
  }
}