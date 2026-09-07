import 'package:flutter/material.dart';

class AnimatedStripedBar extends StatefulWidget {
  const AnimatedStripedBar({
    super.key,
    required this.progress,
    required this.fillColor,
    required this.trackColor,
    required this.height,
    required this.borderRadius,
    required this.stripeSpacing,
    required this.stripeWidth,
    this.stripeColor = const Color(0x4DFFFFFF), // White with 30% opacity
    this.animationDuration = const Duration(seconds: 2),
  });

  final double progress;
  final Color fillColor;
  final Color trackColor;
  final double height;
  final BorderRadius borderRadius;
  final double stripeSpacing;
  final double stripeWidth;
  final Color stripeColor;
  final Duration animationDuration;

  @override
  State<AnimatedStripedBar> createState() => _AnimatedStripedBarState();
}

class _AnimatedStripedBarState extends State<AnimatedStripedBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration)..repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedStripedBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final fillW = constraints.maxWidth * p;

            return Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: widget.trackColor),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: fillW,
                    height: widget.height,
                    child: ClipPath(
                      clipper: _FillShapeClipper(
                        fillWidth: fillW,
                        fillHeight: widget.height,
                        roundTrailing: p >= 1.0,
                      ),
                      child: ColoredBox(
                        color: widget.fillColor,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: _StripesPainter(
                                offset: _controller.value * widget.stripeSpacing,
                                spacing: widget.stripeSpacing,
                                lineColor: widget.stripeColor,
                                lineWidth: widget.stripeWidth,
                              ),
                              child: const SizedBox.expand(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StripesPainter extends CustomPainter {
  _StripesPainter({
    required this.offset,
    required this.spacing,
    required this.lineColor,
    required this.lineWidth,
  });

  final double offset;
  final double spacing;
  final Color lineColor;
  final double lineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final h = size.height;
    final w = size.width;

    for (var x = -h + offset; x < w + h; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + h, h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StripesPainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.spacing != spacing ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth;
  }
}

class _FillShapeClipper extends CustomClipper<Path> {
  _FillShapeClipper({
    required this.fillWidth,
    required this.fillHeight,
    required this.roundTrailing,
  });

  final double fillWidth;
  final double fillHeight;
  final bool roundTrailing;

  @override
  Path getClip(Size size) {
    if (size.width <= 0 || size.height <= 0) return Path();

    final r = size.height / 2;
    final rrect = RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: Radius.circular(r),
      bottomLeft: Radius.circular(r),
      topRight: roundTrailing ? Radius.circular(r) : Radius.zero,
      bottomRight: roundTrailing ? Radius.circular(r) : Radius.zero,
    );
    return Path()..addRRect(rrect);
  }

  @override
  bool shouldReclip(covariant _FillShapeClipper oldClipper) {
    return oldClipper.fillWidth != fillWidth ||
        oldClipper.fillHeight != fillHeight ||
        oldClipper.roundTrailing != roundTrailing;
  }
}
