import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/theme/border/border_radius.dart';
import '../../../core/utils/responsive.dart';
import '../controllers/auth_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = I18n.of(context);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.home),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.home,
                size: 80.w,
                color: colors.iconPrimaryDefault,
              ),
              SizedBox(height: 16.h),
              Text(
                t.welcomeUser('User'),
                style: textStyles.xxl_b,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Bienvenue dans votre nouveau projet Flutter',
                style: textStyles.base.withColor(colors.textDefaultSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}