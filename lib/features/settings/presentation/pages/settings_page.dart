import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = I18n.of(context);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(LucideIcons.palette),
            title: Text(t.appearance),
            subtitle: const Text('Thème, couleurs'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.languages),
            title: Text(t.locale),
            subtitle: const Text('Français, English'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.bell),
            title: Text(t.notifications),
            subtitle: const Text('Push, rappels'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(LucideIcons.logOut, color: colors.iconErrorDefault),
            title: Text(
              t.logout,
              style: textStyles.base_b.withColor(colors.textErrorDefault),
            ),
          ),
        ],
      ),
    );
  }
}