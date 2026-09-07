package com.overheatstudio.my_app

import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val insetsChannel = "com.overheatstudio.my_app/system_insets"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, insetsChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "getTappableBottomInset") {
                    result.success(tappableBottomInset())
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun tappableBottomInset(): Int {
        val rootInsets = ViewCompat.getRootWindowInsets(window.decorView) ?: return 0
        return rootInsets.getInsets(WindowInsetsCompat.Type.tappableElement()).bottom
    }
}
