import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../main.dart';
import '../../interaction/interaction_scope.dart';
import '../../theme/border/border_radius.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/haptic_manager.dart';
import '../../utils/responsive.dart';
import 'tablet_constrained_content.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.title,
    required this.child,
    this.titleWidget,
    this.description,
    this.descriptionWidget,
    this.titleMaxLines = 2,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.disabledHeader = false,
    this.customHeader,
    this.customTrailing,
    this.constrainTabletContentWidth = true,
    this.tabletContentWidthFactor = 0.6,
    this.scrollable = false,
  });

  final String title;
  final Widget? titleWidget;
  final String? description;
  final Widget? descriptionWidget;
  final int titleMaxLines;
  final Widget child;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingIconPressed;
  final bool disabledHeader;
  final Widget? customHeader;
  final Widget? customTrailing;
  final bool constrainTabletContentWidth;
  final double tabletContentWidthFactor;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final colors = context.colors;
    final hasSafeArea = MediaQuery.viewPaddingOf(context).top > 0;

    return Container(
      color: colors.backgroundDefaultDefault,
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: .only(
                right: isTablet ? 24.w : 16.w,
                left: isTablet ? 24.w : 16.w,
                top: hasSafeArea ? 10.h : 24.h,
              ),
              child: scrollable
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          _buildHeader(context, canPop),
                          SizedBox(height: 22.h),
                          _tabletWrappedContent(context),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: .start,
                      children: [
                        _buildHeader(context, canPop),
                        SizedBox(height: 22.h),
                        Expanded(child: _tabletWrappedContent(context)),
                      ],
                    ),
            ),
          ),
          ?customHeader,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.1,
                child: ImageFiltered(
                  imageFilter: .blur(sigmaX: 200, sigmaY: 200),
                  child: Image.asset(
                    'assets/images/backgrounds/bg_shade_mobile.png',
                    width: double.infinity,
                    fit: .fitWidth,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool canPop) {
    final textStyles = context.textStyles;
    final colors = context.colors;
    return Row(
      crossAxisAlignment: customTrailing != null ? .center : .start,
      spacing: 20.w,
      children: [
        if (!disabledHeader)
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                GestureDetector(
                  onTap: canPop
                      ? () {
                          InteractionScope.register(context, source: 'page_layout_back');
                          HapticManager.instance.selectionClick();
                          context.pop();
                        }
                      : null,
                  behavior: .opaque,
                  child: Row(
                    crossAxisAlignment: .center,
                    children: [
                      if (canPop) ...[
                        Icon(
                          LucideIcons.chevronLeft,
                          color: colors.iconDefaultDefault,
                          size: isTablet ? 32.w : 24.w,
                        ),
                        SizedBox(width: 4.w),
                      ],
                      Expanded(
                        child:
                            titleWidget ??
                            Text(
                              title,
                              style: textStyles.xxl_b,
                              maxLines: titleMaxLines,
                              overflow: .ellipsis,
                            ),
                      ),
                    ],
                  ),
                ),
                if (descriptionWidget != null)
                  descriptionWidget!
                else if (description != null)
                  Text(description!, style: textStyles.base.withColor(colors.textDefaultTertiary)),
              ],
            ),
          ),
        if (trailingIcon != null)
          GestureDetector(
            onTap: onTrailingIconPressed == null
                ? null
                : () {
                    InteractionScope.register(context, source: 'page_layout_trailing');
                    onTrailingIconPressed!();
                  },
            child: Container(
              width: isTablet ? 68.w : 48.w,
              height: isTablet ? 68.w : 48.w,
              decoration: BoxDecoration(
                border: .all(color: colors.borderDefaultDefault),
                borderRadius: .all(BRadius.r16),
                color: colors.backgroundDefaultSecondary,
              ),
              child: Padding(
                padding: .all(11.w),
                child: Icon(
                  trailingIcon,
                  color: colors.iconDefaultDefault,
                  size: isTablet ? 32.w : 24.w,
                ),
              ),
            ),
          ),

        ?customTrailing,
      ],
    );
  }

  Widget _tabletWrappedContent(BuildContext context) {
    if (!isTablet || !constrainTabletContentWidth) return child;
    return TabletConstrainedContent(widthFactor: tabletContentWidthFactor, child: child);
  }
}
