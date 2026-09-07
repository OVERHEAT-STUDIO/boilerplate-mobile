import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Corrige le bottom inset Android : la navigation bar gestuelle rapporte un
/// `viewPadding.bottom` trop grand sur certains appareils (notamment quand
/// une zone tappable custom est affichée par le launcher), ce qui pousse le
/// contenu plus haut que nécessaire.
///
/// Sans effet sur iOS (le safe area natif est déjà correct).
class SystemBottomInset extends StatefulWidget {
  const SystemBottomInset({super.key, required this.child});

  final Widget child;

  @override
  State<SystemBottomInset> createState() => _SystemBottomInsetState();
}

class _SystemBottomInsetState extends State<SystemBottomInset>
    with WidgetsBindingObserver {
  static const _channel = MethodChannel(
    'com.overheatstudio.my_app/system_insets',
  );

  double _tappableBottomPx = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() => _refresh();

  Future<void> _refresh() async {
    if (!Platform.isAndroid) return;
    try {
      final px =
          await _channel.invokeMethod<int>('getTappableBottomInset') ?? 0;
      if (!mounted || px.toDouble() == _tappableBottomPx) return;
      setState(() => _tappableBottomPx = px.toDouble());
    } catch (_) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottom = Platform.isAndroid
        ? math.min(
            _tappableBottomPx / mq.devicePixelRatio,
            mq.viewPadding.bottom,
          )
        : 0.0;

    return MediaQuery(
      data: mq.copyWith(
        viewPadding: _withBottom(mq.viewPadding, bottom),
        padding: _withBottom(
          mq.padding,
          math.max(0.0, bottom - mq.viewInsets.bottom),
        ),
      ),
      child: widget.child,
    );
  }

  EdgeInsets _withBottom(EdgeInsets insets, double bottom) =>
      EdgeInsets.fromLTRB(insets.left, insets.top, insets.right, bottom);
}
