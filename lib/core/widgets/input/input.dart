import 'package:flutter/material.dart';

import '../../theme/border/border_radius.dart';
import '../../theme/colors/colors_abstract.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    required this.controller,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
    this.keyboardType,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.onChanged,
    this.icon,
    this.iconColor,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.autofillHints,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textStyle,
    this.focusNode,
    this.labelSuffixWidget,
  });

  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final bool autocorrect;
  final bool enableSuggestions;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final IconData? icon;
  final Color? iconColor;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final EdgeInsets scrollPadding;
  final TextStyle? textStyle;
  final FocusNode? focusNode;
  final Widget? labelSuffixWidget;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    if (widget.focusNode == null) focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  BoxDecoration _decoration(ColorsAbstract colors) {
    final hasError = widget.errorText != null;
    final borderColor = hasError ? colors.borderErrorDefault : colors.borderDefaultSecondary;

    return BoxDecoration(
      color: colors.backgroundDefaultSecondary,
      borderRadius: .all(BRadius.r16),
      border: .all(color: borderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(widget.label!, style: textStyles.base_b),
              if (widget.labelSuffixWidget != null) widget.labelSuffixWidget!,
            ],
          ),
          SizedBox(height: 8.h),
        ],
        Opacity(
          opacity: widget.enabled ? 1 : 0.5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            decoration: _decoration(colors),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
              child: RawScrollbar(
                controller: _scrollController,
                thumbVisibility: widget.maxLines > 1,
                thickness: 3.w,
                radius: BRadius.full,
                mainAxisMargin: 16.h,
                crossAxisMargin: 8.w,
                thumbColor: context.colors.borderDefaultSecondary,
                child: TextField(
                  controller: widget.controller,
                  focusNode: focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  scrollController: _scrollController,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  style: widget.textStyle ?? textStyles.base,
                  cursorColor: colors.iconDefaultDefault,
                  scrollPadding: widget.scrollPadding,
                  keyboardType: widget.keyboardType,
                  autocorrect: widget.autocorrect,
                  enableSuggestions: widget.enableSuggestions,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  onTapOutside: (_) => focusNode.unfocus(),
                  autofillHints: widget.autofillHints,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.transparent,
                    counterText: widget.maxLength != null ? '' : null,
                    prefixIcon: widget.icon != null
                        ? Icon(
                            widget.icon,
                            size: 24.w,
                            color: widget.iconColor ?? colors.iconDefaultDefault,
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: widget.placeholder,
                    hintStyle: (widget.textStyle ?? textStyles.base).withColor(
                      colors.textDefaultSecondary.withValues(alpha: 0.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 6.h),
          Text(widget.errorText!, style: textStyles.sm.withColor(colors.textErrorDefault)),
        ] else if (widget.helperText != null) ...[
          SizedBox(height: 6.h),
          Text(widget.helperText!, style: textStyles.sm.withColor(colors.textDefaultSecondary)),
        ],
      ],
    );
  }
}
