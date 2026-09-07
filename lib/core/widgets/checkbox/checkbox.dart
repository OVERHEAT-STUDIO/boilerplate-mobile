import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../interaction/interaction_scope.dart';
import '../../theme/border/border_radius.dart';
import '../../theme/colors/colors_abstract.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.errorText,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget label;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final effectiveOnChanged = enabled ? onChanged : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Opacity(
          opacity: enabled ? 1 : 0.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LucideCheckbox(
                value: value,
                onChanged: effectiveOnChanged,
                colors: colors,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _LabelTapTarget(
                  enabled: effectiveOnChanged != null,
                  value: value,
                  onToggle: effectiveOnChanged,
                  textStyle: textStyles.base,
                  child: label,
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 6.h),
          Text(
            errorText!,
            style: textStyles.sm.withColor(colors.textErrorDefault),
          ),
        ],
      ],
    );
  }
}

class _LucideCheckbox extends StatelessWidget {
  const _LucideCheckbox({
    required this.value,
    required this.onChanged,
    required this.colors,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final ColorsAbstract colors;

  static const _animDuration = Duration(milliseconds: 115);
  static const _animCurve = Curves.decelerate;
  static const _scaleCurve = Curves.decelerate;

  @override
  Widget build(BuildContext context) {
    final slot = 24.w;
    final iconSize = 16.w;
    final radius = BorderRadius.all(BRadius.r8);
    final interactive = onChanged != null;
    final target = value ? 1.0 : 0.0;

    final box = SizedBox(
      width: slot,
      height: slot,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: const SizedBox.expand()
                  .animate(target: target)
                  .custom(
                    duration: _animDuration,
                    curve: _animCurve,
                    builder: (_, progress, __) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            Colors.transparent,
                            colors.backgroundPrimaryDefault,
                            progress,
                          )!,
                          borderRadius: radius,
                          border: Border.all(
                            width: 1,
                            color: Color.lerp(
                              colors.borderDefaultSecondary,
                              colors.backgroundPrimaryDefault,
                              progress,
                            )!,
                          ),
                        ),
                        child: const SizedBox.expand(),
                      );
                    },
                  ),
            ),
            Center(
              child: IgnorePointer(
                child: Icon(
                  LucideIcons.check600,
                  size: iconSize,
                  color: Colors.white,
                )
                    .animate(target: target)
                    .fade(
                      begin: 0,
                      end: 1,
                      duration: _animDuration,
                      curve: _animCurve,
                    )
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: _animDuration,
                      curve: _scaleCurve,
                      alignment: Alignment.center,
                    ),
              ),
            ),
          ],
        ),
      ),
    );

    return Semantics(
      checked: value,
      enabled: interactive,
      child: interactive
          ? Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  InteractionScope.register(context, source: 'checkbox');
                  onChanged!(!value);
                },
                borderRadius: radius,
                child: box,
              ),
            )
          : box,
    );
  }
}

class _LabelTapTarget extends StatelessWidget {
  const _LabelTapTarget({
    required this.enabled,
    required this.value,
    required this.onToggle,
    required this.textStyle,
    required this.child,
  });

  final bool enabled;
  final bool value;
  final ValueChanged<bool?>? onToggle;
  final TextStyle textStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final merged = DefaultTextStyle.merge(
      style: textStyle,
      child: child,
    );
    if (!enabled || onToggle == null) {
      return merged;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        InteractionScope.register(context, source: 'checkbox_label');
        onToggle!(!value);
      },
      child: merged,
    );
  }
}
