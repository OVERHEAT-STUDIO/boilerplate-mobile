import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/border/border_radius.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';
import 'button.dart';
import 'button_palette.dart';

class ProgressButton extends StatefulWidget {
  final ButtonType type;
  final String text;

  final int progress;

  final Duration? remaining;

  const ProgressButton({
    super.key,
    required this.type,
    required this.text,
    required this.progress,
    this.remaining,
  });

  @override
  State<ProgressButton> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> with SingleTickerProviderStateMixin {
  static const double _resyncThreshold = 0.05;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: _target,
    duration: 1.seconds,
  );

  double get _target => (widget.progress / 100.0).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _animate();
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress || widget.remaining != oldWidget.remaining) {
      _animate();
    }
  }

  void _animate() {
    final remaining = widget.remaining;

    if (remaining == null) {
      _controller.animateTo(_target, duration: 1.seconds, curve: Curves.linear);
      return;
    }

    if ((_controller.value - _target).abs() > _resyncThreshold) {
      _controller.value = _target;
    }

    if (remaining <= Duration.zero) {
      _controller.value = 1;
      return;
    }

    _controller.animateTo(1, duration: remaining, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;
    final palette = ButtonPalette.palette(widget.type, colors);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: palette.background.withValues(alpha: 0.5),
        borderRadius: .all(BRadius.r16),
      ),
      child: ClipRRect(
        borderRadius: .all(BRadius.r16),
        child: Stack(
          alignment: .center,
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: .centerLeft,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) => Container(
                        width: constraints.maxWidth * _controller.value,
                        color: palette.background,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: .all(16.w),
              child: IconTheme(
                data: IconThemeData(color: palette.iconColor),
                child: Row(
                  mainAxisAlignment: .center,
                  mainAxisSize: .max,
                  children: [
                    Text(widget.text, style: textStyles.lg_b.copyWith(color: palette.foreground)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
