import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n/i18n.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/border/border_radius.dart';
import '../../../../core/utils/responsive.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final t = I18n.of(context);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.login),
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(t.errorOccurred)),
        data: (state) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      LucideIcons.logIn,
                      size: 64.w,
                      color: colors.iconPrimaryDefault,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      t.loginTitle,
                      style: textStyles.xxl_b,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      t.loginSubtitle,
                      style: textStyles.base.withColor(colors.textDefaultSecondary),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),
                    if (state.errorMessage != null)
                      Container(
                        padding: EdgeInsets.all(12.w),
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: colors.backgroundErrorDefault,
                          borderRadius: BorderRadius.all(BRadius.r8),
                        ),
                        child: Text(
                          state.errorMessage!,
                          style: textStyles.sm.withColor(colors.textErrorDefault),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .login('demo', 'demo');
                      },
                      child: Text(t.login),
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text('${t.noAccount} ${t.register}'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}