import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';

Future<T?> showAppCupertinoSheet<T>(
  BuildContext context, {
  required ScrollableWidgetBuilder contentBuilder,
}) {
  return showCupertinoSheet<T>(
    context: context,
    scrollableBuilder: (sheetContext, scrollController) {
      final colors = sheetContext.colors;

      return Material(
        type: MaterialType.transparency,
        child: CupertinoPageScaffold(
          backgroundColor: colors.backgroundDefaultDefault,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(child: contentBuilder(sheetContext, scrollController)),
                Positioned(
                  top: 12.h,
                  right: 16.w,
                  child: GestureDetector(
                    onTap: () => Navigator.of(sheetContext).maybePop(),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(color: colors.backgroundDefaultSecondary, shape: BoxShape.circle),
                      child: Icon(LucideIcons.x500, size: 18.w, color: colors.iconDefaultDefault),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
