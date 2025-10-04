package com.example.test_subject_1

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.test_subject_1.BuildConfig

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flavor"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getFlavor") {
                    val flavor = BuildConfig.FLAVOR
                    result.success(flavor)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getCurrentFlavor(): String {
        return try {
            val buildConfigClass = Class.forName("${applicationContext.packageName}.BuildConfig")
            val flavorField = buildConfigClass.getField("FLAVOR")
            flavorField.get(null) as String
        } catch (e: Exception) {
            "unknown"
        }
    }
}
