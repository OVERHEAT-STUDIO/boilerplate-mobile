import 'package:vibration/vibration.dart';

class HapticManager {
  HapticManager._();
  static final instance = HapticManager._();

  Future<bool> _isSupported = Vibration.hasVibrator() ?? Future.value(false);
  bool _useHaptics = true;

  Future<void> loadUseHaptics() async {
    final supported = await _isSupported;
    _useHaptics = supported;
  }

  Future<void> light() async {
    if (!_useHaptics) return;
    await Vibration.vibrate(duration: 10, amplitude: 64);
  }

  Future<void> medium() async {
    if (!_useHaptics) return;
    await Vibration.vibrate(duration: 20, amplitude: 128);
  }

  Future<void> heavy() async {
    if (!_useHaptics) return;
    await Vibration.vibrate(duration: 40, amplitude: 255);
  }

  Future<void> success() async {
    if (!_useHaptics) return;
    await Vibration.vibrate(pattern: [0, 20, 50, 20]);
  }

  Future<void> error() async {
    if (!_useHaptics) return;
    await Vibration.vibrate(pattern: [0, 40, 100, 60, 100, 40]);
  }
}