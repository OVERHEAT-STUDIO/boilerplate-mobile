import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/border/border_radius.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';

Future<T?> showAppModal<T>(
  BuildContext context, {
  required Widget child,
  String? title,
  Widget? icon,
}) {
  final colors = context.colors;
  final textStyles = context.textStyles;
  final isTablet = Responsive(context).isTablet;

  return showDialog<T>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.30),
    builder: (dialogContext) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * (isTablet ? 0.4 : 0.88)),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  clipBehavior: .antiAlias,
                  decoration: BoxDecoration(
                    color: colors.backgroundDefaultDefault,
                    borderRadius: BorderRadius.all(BRadius.r24),
                    border: Border.all(color: colors.borderDefaultDefault, width: 1),
                  ),
                  child: Padding(
                    padding: .all(24.w),
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .stretch,
                      spacing: 15.h,
                      children: [
                        Row(
                          crossAxisAlignment: .center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  if (icon != null) ...[icon, SizedBox(width: 8.w)],
                                  if (title != null)
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: textStyles.xl_b.withColor(
                                          colors.textDefaultDefault,
                                        ),
                                        maxLines: 1,
                                        overflow: .ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: GestureDetector(
                                onTap: () => Navigator.of(dialogContext).maybePop(),
                                child: Center(
                                  child: Icon(
                                    LucideIcons.x500,
                                    size: 24.w,
                                    color: colors.iconDefaultDefault,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
