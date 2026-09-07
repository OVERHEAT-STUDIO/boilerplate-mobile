import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle? style;
  final TextStyle? highlightStyle;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlight,
    this.style,
    this.highlightStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty) {
      return Text(text, style: style);
    }

    final index = text.indexOf(highlight);
    if (index == -1) {
      return Text(text, style: style);
    }

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: highlight,
            style: highlightStyle ?? const TextStyle(fontWeight: .bold),
          ),
          TextSpan(text: text.substring(index + highlight.length)),
        ],
      ),
    );
  }
}
