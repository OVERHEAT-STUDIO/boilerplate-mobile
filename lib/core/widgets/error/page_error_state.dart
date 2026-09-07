import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i18n/i18n.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../api/api_exception.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';
import '../button/button.dart';
import '../snackbar/app_snackbar.dart';

/// Écran d'erreur générique : icône + message, avec actions optionnelles
/// (contacter le support, copier les logs, réessayer).
class PageErrorState extends StatelessWidget {
  const PageErrorState({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
    this.onContactSupport,
  });

  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  /// Si fourni, affiche un bouton "Contacter le support" (ex: ouvrir une
  /// [showAppBottomSheet] projet-spécifique).
  final VoidCallback? onContactSupport;

  Future<String> _buildDiagnosticsText(BuildContext context) async {
    final mq = MediaQuery.maybeOf(context);
    final pkg = await PackageInfo.fromPlatform();

    final buf = StringBuffer();
    buf.writeln('--- App ---');
    buf.writeln('version: ${pkg.version}');
    buf.writeln('buildNumber: ${pkg.buildNumber}');

    buf.writeln();
    buf.writeln('--- Device & display ---');
    buf.writeln('targetPlatform: $defaultTargetPlatform');
    if (!kIsWeb) {
      buf.writeln('operatingSystem: ${Platform.operatingSystem}');
      buf.writeln('operatingSystemVersion: ${Platform.operatingSystemVersion}');
    }
    if (mq != null) {
      buf.writeln('screenLogical: ${mq.size.width.toStringAsFixed(1)}x${mq.size.height.toStringAsFixed(1)}');
      buf.writeln('devicePixelRatio: ${mq.devicePixelRatio.toStringAsFixed(2)}');
      buf.writeln('platformBrightness: ${mq.platformBrightness}');
    }

    buf.writeln();
    buf.writeln('--- Runtime ---');
    buf.writeln('debugMode: $kDebugMode');
    buf.writeln('timestampUtc: ${DateTime.now().toUtc().toIso8601String()}');

    buf.writeln();
    buf.writeln('--- Error ---');
    buf.writeln('runtimeType: ${error.runtimeType}');
    if (error is ApiException) {
      buf.writeln('apiErrorCode: ${(error as ApiException).apiErrorCode}');
      buf.writeln('httpCode: ${(error as ApiException).httpCode}');
    }
    buf.writeln('message: $error');

    if (stackTrace != null) {
      buf.writeln();
      buf.writeln('--- Stack trace ---');
      buf.writeln(stackTrace);
    }

    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: .symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.h,
          children: [
            Icon(
              LucideIcons.ban,
              color: colors.iconErrorDefault,
              size: 48.w,
            ),
            Column(
              children: [
                Text(
                  I18n.current.pageErrorTitle,
                  style: textStyles.xl_b,
                  textAlign: TextAlign.center,
                ),
                Text(
                  I18n.current.pageErrorSubtitle,
                  style: textStyles.base.copyWith(color: colors.textDefaultSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (onContactSupport != null)
              Button(
                onTap: onContactSupport!,
                text: I18n.current.contactSupport,
                type: ButtonType.primary,
              ),
            Button(
              onTap: () {
                unawaited(() async {
                  final payload = await _buildDiagnosticsText(context);
                  if (!context.mounted) return;
                  await Clipboard.setData(ClipboardData(text: payload));
                  if (!context.mounted) return;
                  showAppSnackBar(
                    context,
                    message: I18n.current.pageErrorLogsCopied,
                    type: AppSnackBarType.success,
                  );
                }());
              },
              text: I18n.current.pageErrorCopyLogs,
              type: onContactSupport != null ? ButtonType.base : ButtonType.primary,
            ),
            if (onRetry != null)
              Button(
                onTap: onRetry!,
                text: I18n.current.retry,
                type: ButtonType.ghost,
              ),
          ],
        ),
      ),
    );
  }
}
