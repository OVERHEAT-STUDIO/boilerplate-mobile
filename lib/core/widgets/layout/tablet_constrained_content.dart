import 'package:flutter/material.dart';

import '../../utils/responsive.dart';

class TabletConstrainedContent extends StatelessWidget {
  const TabletConstrainedContent({
    super.key,
    required this.child,
    this.widthFactor = 0.6, // Default to 60% of the available width on tablets
    this.maxWidth, // Fixed max width, takes precedence over widthFactor when set
  });

  final Widget child;
  final double widthFactor;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    if (!responsive.isTablet) return child;

    if (maxWidth != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth!), child: child),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * widthFactor),
            child: child,
          ),
        );
      },
    );
  }
}
