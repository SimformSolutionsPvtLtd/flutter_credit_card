package com.simform.flutter_credit_card

import android.app.Activity
import android.content.Context
import android.os.Build
import android.view.Display
import android.view.WindowManager
import androidx.annotation.ChecksSdkIntAtLeast
import com.simform.flutter_credit_card.gyroscope.GyroscopeChannelImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger

@ChecksSdkIntAtLeast(api = Build.VERSION_CODES.R)
private val isAtLeastOsR: Boolean = Build.VERSION.SDK_INT >= Build.VERSION_CODES.R

/** FlutterCreditCardPlugin */
class FlutterCreditCardPlugin : FlutterPlugin, ActivityAware {
    private var gyroscopeChannel: GyroscopeChannelImpl? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        initializeChannels(binding.applicationContext, binding.binaryMessenger)

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) =
        disposeChannels()

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = if (isAtLeastOsR) binding.activity else null
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = if (isAtLeastOsR) binding.activity else null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    private fun initializeChannels(context: Context, messenger: BinaryMessenger) {
        gyroscopeChannel = GyroscopeChannelImpl(context, messenger) { getViewDisplay(context) }
    }

    private fun getViewDisplay(context: Context): Display? {
        if (isAtLeastOsR) {
            return activity?.display
        } else {
            @Suppress("DEPRECATION")
            return (context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).defaultDisplay
        }
    }

    private fun disposeChannels() {
        gyroscopeChannel?.dispose()
        gyroscopeChannel = null
        activity = null
    }
}
