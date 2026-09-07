import 'package:flutter/material.dart';

import '../../theme/border/border_radius.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';

class AppPopupMenuItem<T> {
  const AppPopupMenuItem({required this.value, required this.icon, required this.label});

  final T value;
  final IconData icon;
  final String label;
}

Future<T?> showAppPopupMenu<T>(
  BuildContext context, {
  required Offset globalPosition,
  required List<AppPopupMenuItem<T>> items,
}) {
  final colors = context.colors;
  final textStyles = context.textStyles;
  final overlaySize = Overlay.of(context).context.size ?? MediaQuery.sizeOf(context);

  return showMenu<T>(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromCenter(center: globalPosition, width: 1, height: 1),
      Offset.zero & overlaySize,
    ),
    color: colors.backgroundDefaultSecondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(BRadius.r16),
      side: BorderSide(color: colors.borderDefaultDefault),
    ),
    items: items
        .map(
          (item) => PopupMenuItem<T>(
            value: item.value,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              spacing: 8.w,
              children: [
                Icon(item.icon, size: 18.w, color: colors.iconDefaultDefault),
                Text(item.label, style: textStyles.sm_b),
              ],
            ),
          ),
        )
        .toList(),
  );
}
