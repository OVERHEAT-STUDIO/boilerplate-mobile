import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../interaction/interaction_scope.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/border/border_radius.dart';
import '../../theme/colors/colors_abstract.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/haptic_manager.dart';
import '../../utils/responsive.dart';

class SelectOption<T> {
  const SelectOption({required this.value, required this.label, this.leadingAssetPath});

  final T value;
  final String label;

  final String? leadingAssetPath;
}

class Select<T> extends StatefulWidget {
  const Select({
    super.key,
    required this.options,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.enabled = true,
  });

  final List<SelectOption<T>> options;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> {
  static const _animDuration = Duration(milliseconds: 220);
  static const _animCurve = Curves.easeInOutCubic;

  bool _open = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();

  @override
  void didUpdateWidget(Select<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled || widget.options.isEmpty) {
      if (_open) _close();
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  SelectOption<T>? get _selected {
    for (final o in widget.options) {
      if (o.value == widget.value) return o;
    }
    return null;
  }

  void _toggle() {
    if (!widget.enabled || widget.options.isEmpty) return;
    InteractionScope.register(context, source: 'select_toggle');
    HapticManager.instance.selectionClick();
    _open ? _close() : _openPanel();
  }

  void _openPanel() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _open = true);
    _overlayEntry!.markNeedsBuild();
  }

  void _close() {
    if (!_open) return;
    setState(() => _open = false);
    _overlayEntry?.markNeedsBuild();
    final entry = _overlayEntry;
    _overlayEntry = null;
    Future.delayed(_animDuration, () => entry?.remove());
  }

  void _pick(SelectOption<T> option) {
    InteractionScope.register(context, source: 'select_option');
    HapticManager.instance.selectionClick();
    widget.onChanged(option.value);
    _close();
  }

  OverlayEntry _createOverlayEntry() {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final renderBox = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final width = renderBox?.size.width ?? 0;

    return OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                HapticManager.instance.selectionClick();
                _close();
              },
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: Offset(0, 8.h),
            child: SizedBox(
              width: width,
              child: _buildAnimatedOptionsPanel(colors, textStyles),
            ),
          ),
        ],
      ),
    );
  }

  static bool _hasLeading(String? path) => path != null && path.isNotEmpty;

  Widget _leadingFlag(String path) {
    return Image.asset(path, width: 24.w, fit: BoxFit.cover);
  }

  static BorderRadius _itemBorderRadius(int index, int length) {
    final first = index == 0;
    final last = index == length - 1;
    if (first && last) {
      return BorderRadius.all(BRadius.r16);
    }
    if (first) {
      return BorderRadius.vertical(top: BRadius.r16);
    }
    if (last) {
      return BorderRadius.vertical(bottom: BRadius.r16);
    }
    return BorderRadius.zero;
  }

  Widget _buildOptionsList(ColorsAbstract colors, AppTextStyles textStyles) {
    final n = widget.options.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < n; i++) ...[
          if (i > 0) Divider(height: 1, thickness: 1, color: colors.borderDefaultDefault),
          Material(
            color: widget.options[i].value == widget.value ? colors.backgroundDefaultSecondary : Colors.transparent,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: _itemBorderRadius(i, n)),
            child: InkWell(
              borderRadius: _itemBorderRadius(i, n),
              onTap: () => _pick(widget.options[i]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    if (_hasLeading(widget.options[i].leadingAssetPath)) ...[
                      _leadingFlag(widget.options[i].leadingAssetPath!),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: Text(
                        widget.options[i].label,
                        style: textStyles.base.withColor(colors.textDefaultDefault),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnimatedOptionsPanel(ColorsAbstract colors, AppTextStyles textStyles) {
    final panel = Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.backgroundDefaultDefault,
          borderRadius: BorderRadius.all(BRadius.r16),
          border: Border.all(color: colors.borderDefaultDefault, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildOptionsList(colors, textStyles),
      ),
    );

    return panel
        .animate(target: _open ? 1.0 : 0.0)
        .fade(duration: _animDuration, curve: _animCurve)
        .slideY(begin: -0.06, end: 0, duration: _animDuration, curve: _animCurve)
        .custom(
          duration: _animDuration,
          curve: _animCurve,
          builder: (_, value, child) => ClipRect(
            child: Align(alignment: Alignment.topCenter, heightFactor: value.clamp(0.0, 1.0), child: child),
          ),
        );
  }

  BoxDecoration _triggerDecoration({required ColorsAbstract colors, required bool focused}) {
    final hasError = widget.errorText != null;
    final borderColor = hasError ? colors.borderErrorDefault : colors.borderDefaultDefault;

    return BoxDecoration(
      color: colors.backgroundDefaultSecondary,
      borderRadius: BorderRadius.all(BRadius.r16),
      border: Border.all(color: borderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final disabledFg = colors.iconWarningTertiary;

    final selected = _selected;
    final display = selected?.label ?? widget.hint ?? '';
    final isPlaceholder = selected == null;

    final fg = widget.enabled ? colors.textDefaultDefault : disabledFg;
    final hintStyle = textStyles.base.withColor(widget.enabled ? colors.textDefaultSecondary : disabledFg);
    final valueStyle = textStyles.base.withColor(fg);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[Text(widget.label!, style: textStyles.base_b), SizedBox(height: 8.h)],
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              key: _triggerKey,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: .symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: _triggerDecoration(colors: colors, focused: _open),
              child: Row(
                children: [
                  if (!isPlaceholder && _hasLeading(selected.leadingAssetPath)) ...[
                    _leadingFlag(selected.leadingAssetPath!),
                    SizedBox(width: 8.w),
                  ],
                  Expanded(
                    child: Text(display, style: isPlaceholder ? hintStyle : valueStyle, overflow: .ellipsis),
                  ),
                  SizedBox(width: 8.w),
                  Transform.rotate(
                    angle: _open ? math.pi : 0,
                    child: Icon(
                      LucideIcons.chevronDown,
                      size: 18.w,
                      color: widget.enabled ? colors.iconDefaultDefault : disabledFg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 6.h),
          Text(widget.errorText!, style: textStyles.xs.withColor(colors.borderErrorDefault)),
        ] else if (widget.helperText != null) ...[
          SizedBox(height: 6.h),
          Text(widget.helperText!, style: textStyles.xs.withColor(colors.textDefaultSecondary)),
        ],
      ],
    );
  }
}
