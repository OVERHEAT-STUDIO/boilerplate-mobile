import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../main.dart';
import '../../theme/border/border_radius.dart';
import '../../theme/colors/colors_abstract.dart';
import '../../theme/theme_extensions.dart';
import '../../utils/responsive.dart';

enum AppSnackBarType { success, warning, error, info }

typedef _SnackBarPalette = ({Color iconColor, Color border, IconData icon});

_SnackBarPalette _palette(AppSnackBarType type, ColorsAbstract colors) {
  return switch (type) {
    AppSnackBarType.success => (
      iconColor: colors.backgroundPrimaryDefault,
      border: colors.backgroundPrimaryDefault,
      icon: LucideIcons.check,
    ),
    AppSnackBarType.warning => (
      iconColor: colors.borderWarningDefault,
      border: colors.borderWarningDefault,
      icon: LucideIcons.triangleAlert,
    ),
    AppSnackBarType.error => (
      iconColor: colors.borderErrorDefault,
      border: colors.borderErrorDefault,
      icon: LucideIcons.x,
    ),
    AppSnackBarType.info => (
      iconColor: colors.borderInfoDefault,
      border: colors.borderInfoDefault,
      icon: LucideIcons.info,
    ),
  };
}

_AppSnackBarBodyState? _activeSnackBarState;

Future<void> _showAppSnackBarChain = Future.value();

Future<void> showAppSnackBar(
  BuildContext context, {
  required String message,
  AppSnackBarType type = AppSnackBarType.success,
}) {
  final messenger = ScaffoldMessenger.of(context);
  final palette = _palette(type, context.colors);
  final isTablet = Responsive(context).isTablet;
  final body = _AppSnackBarBody(message: message, palette: palette);

  _showAppSnackBarChain = _showAppSnackBarChain.then((_) async {
    final previous = _activeSnackBarState;
    if (previous != null) await previous._closeWithAnimation(dismissed: true);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        padding: EdgeInsets.zero,
        margin: isTablet ? null : EdgeInsets.fromLTRB(16.w, 0, 16.w, 36.h),
        width: isTablet ? 520.w : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.none,
        duration: const Duration(seconds: 5),
        clipBehavior: Clip.none,
        content: body,
      ),
    );
  });
  return _showAppSnackBarChain;
}

class _AppSnackBarBody extends StatefulWidget {
  const _AppSnackBarBody({required this.message, required this.palette});

  final String message;
  final _SnackBarPalette palette;

  @override
  State<_AppSnackBarBody> createState() => _AppSnackBarBodyState();
}

class _AppSnackBarBodyState extends State<_AppSnackBarBody> with TickerProviderStateMixin {
  static const _totalDuration = Duration(seconds: 5);
  static const _motionDuration = Duration(milliseconds: 200);
  static const _motionDurationDismissed = Duration(milliseconds: 100);
  static const _motionCurve = Curves.easeInOutCubic;
  static const _dragDismissThreshold = 64.0;
  static const _dragDismissVelocity = 700.0;
  static const _settleDuration = Duration(milliseconds: 180);
  static const _dragExitDuration = Duration(milliseconds: 160);

  late final AnimationController _progressController;
  late final AnimationController _motionController;
  late final Animation<double> _motionOpacity;
  late final Animation<Offset> _motionSlide;

  Future<void>? _closeFuture;
  bool _isClosing = false;

  AnimationController? _dragSettleController;
  bool _isDragging = false;
  double _dragOffset = 0;
  double _dragOpacity = 1;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(vsync: this, duration: _motionDuration);
    _motionOpacity = CurvedAnimation(parent: _motionController, curve: _motionCurve);
    _motionSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _motionController, curve: _motionCurve));

    _progressController = AnimationController(vsync: this, duration: _totalDuration)
      ..addStatusListener(_onProgressStatus)
      ..forward();

    _activeSnackBarState = this;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isClosing) _motionController.forward();
    });
  }

  void _onProgressStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _closeWithAnimation(dismissed: false);
  }

  @override
  void dispose() {
    if (_activeSnackBarState == this) _activeSnackBarState = null;
    _dragSettleController?.dispose();
    _progressController.dispose();
    _motionController.dispose();
    super.dispose();
  }

  Future<void> _closeWithAnimation({required bool dismissed}) {
    if (_closeFuture != null) return _closeFuture!;
    if (!mounted) return Future.value();
    _isClosing = true;
    _progressController.stop();
    _closeFuture = _runClose(dismissed);
    return _closeFuture!;
  }

  Future<void> _runClose(bool dismissed) async {
    try {
      final duration = dismissed ? _motionDurationDismissed : _motionDuration;
      await _motionController.animateTo(0, duration: duration, curve: _motionCurve);
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    } finally {
      _closeFuture = null;
    }
  }

  void _dismiss() => _closeWithAnimation(dismissed: false);

  Future<void> _dismissByDrag() {
    if (_closeFuture != null) return _closeFuture!;
    if (!mounted) return Future.value();
    _isClosing = true;
    _progressController.stop();
    _closeFuture = _runCloseByDrag();
    return _closeFuture!;
  }

  Future<void> _runCloseByDrag() async {
    try {
      await _animateDrag(toOffset: _dragOffset + 220, toOpacity: 0, duration: _dragExitDuration);
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    } finally {
      _closeFuture = null;
    }
  }

  void _pauseTimer() {
    if (_isClosing) return;
    if (_progressController.isAnimating) _progressController.stop(canceled: false);
  }

  void _resumeTimer() {
    if (_isClosing) return;
    if (!_progressController.isCompleted) _progressController.forward();
  }

  Future<void> _animateDrag({required double toOffset, double? toOpacity, required Duration duration}) async {
    _dragSettleController?.dispose();
    final controller = AnimationController(vsync: this, duration: duration);
    _dragSettleController = controller;
    final fromOffset = _dragOffset;
    final fromOpacity = _dragOpacity;
    final targetOpacity = toOpacity ?? _dragOpacity;
    final curved = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    curved.addListener(() {
      if (!mounted) return;
      setState(() {
        _dragOffset = lerpDouble(fromOffset, toOffset, curved.value)!;
        _dragOpacity = lerpDouble(fromOpacity, targetOpacity, curved.value)!;
      });
    });
    try {
      await controller.forward();
    } finally {
      if (_dragSettleController == controller) _dragSettleController = null;
      controller.dispose();
    }
  }

  void _onPointerDown(PointerDownEvent _) => _pauseTimer();

  void _onPointerUp(PointerUpEvent _) {
    if (!_isDragging) _resumeTimer();
  }

  void _onDragStart(DragStartDetails _) {
    if (_isClosing) return;
    _isDragging = true;
    _dragSettleController?.dispose();
    _dragSettleController = null;
    _pauseTimer();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isClosing) return;
    setState(() => _dragOffset = (_dragOffset + details.delta.dy).clamp(0.0, double.infinity));
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isClosing) return;
    _isDragging = false;
    final shouldDismiss =
        _dragOffset > _dragDismissThreshold || details.velocity.pixelsPerSecond.dy > _dragDismissVelocity;
    if (shouldDismiss) {
      _dismissByDrag();
    } else {
      _settleBack();
    }
  }

  Future<void> _settleBack() async {
    await _animateDrag(toOffset: 0, toOpacity: 1, duration: _settleDuration);
    _resumeTimer();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final p = widget.palette;
    final colors = context.colors;

    final radius = BorderRadius.all(BRadius.r16);
    final card = Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: colors.textPrimaryDefault.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            color: colors.backgroundDefaultDefault,
            borderRadius: radius,
            border: .all(color: colors.borderDefaultDefault),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: .symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(p.icon, size: 24.w, color: p.iconColor),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(widget.message, style: textStyles.base, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(width: 4.w),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tight(Size(40.w, 40.w)),
                      icon: Icon(LucideIcons.x, size: 24.w, color: colors.iconDefaultTertiary),
                      onPressed: _dismiss,
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                    ),
                  ],
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, _) {
                      final t = 1.0 - _progressController.value;
                      return SizedBox(
                        height: 4.h,
                        width: constraints.maxWidth,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ColoredBox(color: p.border.withValues(alpha: 0.2)),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: t.clamp(0.0, 1.0),
                                heightFactor: 1,
                                alignment: Alignment.centerLeft,
                                child: ColoredBox(color: p.border),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: .only(bottom: isTablet ? 32.h : 0),
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerCancel: (_) {
          if (!_isDragging) _resumeTimer();
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragStart: _onDragStart,
          onVerticalDragUpdate: _onDragUpdate,
          onVerticalDragEnd: _onDragEnd,
          child: Transform.translate(
            offset: Offset(0, _dragOffset),
            child: Opacity(
              opacity: _dragOpacity,
              child: Material(
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: _motionOpacity,
                  child: SlideTransition(position: _motionSlide, child: card),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
