import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchInApp(String url) async {
  try {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('[LaunchURL] Cannot launch: $url');
    }
  } catch (e) {
    debugPrint('[LaunchURL] Error: $e');
  }
}