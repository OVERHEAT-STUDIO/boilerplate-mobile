import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/border/border_radius.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';

class _FirstFrameCallback extends StatefulWidget {
  const _FirstFrameCallback({this.onShown, required this.child});

  final VoidCallback? onShown;
  final Widget child;

  @override
  State<_FirstFrameCallback> createState() => _FirstFrameCallbackState();
}

class _FirstFrameCallbackState extends State<_FirstFrameCallback> {
  @override
  void initState() {
    super.initState();
    final cb = widget.onShown;
    if (cb != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => cb());
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  String? title,
  VoidCallback? whenFirstFrame,
  Widget? icon,
}) {
  final colors = context.colors;
  final textStyles = context.textStyles;
  final isTablet = Responsive(context).isTablet;

  Widget sheetBody(BuildContext navigatorContext) {
    final keyboardInset = isTablet
        ? 0.0
        : MediaQuery.viewInsetsOf(navigatorContext).bottom;
    final bottomSafeArea = isTablet
        ? 0.0
        : MediaQuery.viewPaddingOf(navigatorContext).bottom;
    final effectiveBottom = keyboardInset > 0 ? keyboardInset : bottomSafeArea;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.backgroundDefaultDefault,
          borderRadius: isTablet
              ? BorderRadius.all(BRadius.r24)
              : const BorderRadius.vertical(top: BRadius.r24),
          border: isTablet
              ? Border.all(color: colors.borderDefaultDefault, width: 1)
              : Border(
                  top: BorderSide(color: colors.borderDefaultDefault, width: 1),
                ),
        ),
        child: Padding(
          padding: .only(
            right: 24.w,
            left: 24.w,
            top: 20.h,
            bottom: 32.h + effectiveBottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 15.h,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (icon != null) ...[icon, SizedBox(width: 8.w)],
                        if (title != null)
                          Text(
                            title,
                            style: textStyles.xxl_b.withColor(
                              colors.textDefaultDefault,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: GestureDetector(
                      onTap: () => Navigator.of(navigatorContext).maybePop(),
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
              whenFirstFrame != null
                  ? _FirstFrameCallback(onShown: whenFirstFrame, child: child)
                  : child,
            ],
          ),
        ),
      ),
    );
  }

  if (isTablet) {
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
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.4,
                ), // 40% of tablet screen width
                child: sheetBody(dialogContext),
              ),
            );
          },
        );
      },
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    barrierColor: Colors.black.withValues(alpha: 0.30),
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(ctx).maybePop(),
              child: const SizedBox.expand(),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: sheetBody(ctx)),
        ],
      );
    },
  );
}
