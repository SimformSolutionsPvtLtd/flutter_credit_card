package com.simform.flutter_credit_card.gyroscope

import Constants
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.SensorManager
import android.view.Display
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

internal class GyroscopeChannelImpl(
    private val context: Context,
    private val messenger: BinaryMessenger,
    private val getDisplay: () -> Display?,
) : MethodCallHandler {
    private val methodChannel: MethodChannel
    private var eventChannel: EventChannel? = null
    private var streamHandler: GyroscopeStreamHandler? = null

    init {
        eventStreamSetup()
        methodChannel = MethodChannel(messenger, Constants.METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            Constants.INITIATE_EVENTS -> {
                eventStreamSetup()
                result.success(null)
            }

            Constants.IS_GYRO_AVAILABLE -> result.success(hasGyroAvailability())

            Constants.CANCEL_EVENTS -> {
                eventStreamDisposal()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    fun dispose() {
        eventStreamDisposal()
        methodChannel.setMethodCallHandler(null)
    }

    private fun eventStreamSetup() {
        if (!hasGyroAvailability()) return

        val sensorsManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

        eventChannel = if (eventChannel == null) EventChannel(
            messenger,
            Constants.GYROSCOPE_CHANNEL_NAME,
        ) else eventChannel

        streamHandler = GyroscopeStreamHandler(getDisplay(), sensorsManager)
        eventChannel!!.setStreamHandler(streamHandler)
    }

    private fun eventStreamDisposal() {
        streamHandler?.onCancel(null)
        eventChannel?.setStreamHandler(null)
        eventChannel = null
    }

    private fun hasGyroAvailability(): Boolean =
        context.packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_GYROSCOPE)
}
