import 'dart:math';
import 'package:flutter/material.dart';

/// Bordure animée en dégradé arc-en-ciel tournant, à activer conditionnellement
/// (ex: mise en avant d'un item premium/actif).
class RainbowBorder extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final bool active;

  const RainbowBorder({
    super.key,
    required this.child,
    required this.borderRadius,
    this.borderWidth = 2.0,
    this.active = false,
  });

  @override
  State<RainbowBorder> createState() => _RainbowBorderState();
}

class _RainbowBorderState extends State<RainbowBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    if (widget.active) _controller.repeat();
  }

  @override
  void didUpdateWidget(RainbowBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _controller.repeat();
    } else if (!widget.active && oldWidget.active) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _RainbowBorderPainter(
                rotation: _controller.value,
                borderRadius: widget.borderRadius,
                borderWidth: widget.borderWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RainbowBorderPainter extends CustomPainter {
  final double rotation;
  final double borderRadius;
  final double borderWidth;

  static const _colors = [
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFEAB308),
    Color(0xFFF59E0B),
  ];

  const _RainbowBorderPainter({
    required this.rotation,
    required this.borderRadius,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final gradient = SweepGradient(
      colors: _colors,
      transform: GradientRotation(rotation * 2 * pi),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_RainbowBorderPainter old) => old.rotation != rotation;
}
