package com.simform.flutter_credit_card

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** FlutterCreditCardPlugin */
class FlutterCreditCardPlugin: FlutterPlugin {
  private lateinit var gyroscopeChannel: EventChannel

  private lateinit var methodChannel: MethodChannel

  private lateinit var gyroScopeStreamHandler: StreamHandlerImpl

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    setupEventChannels(binding.applicationContext, binding.binaryMessenger)
    setupMethodChannel(binding.applicationContext, binding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    teardownEventChannels()
    teardownMethodChannel()
  }

  private fun setupEventChannels(context: Context, messenger: BinaryMessenger) {
    val sensorsManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager

    gyroscopeChannel = EventChannel(messenger, GYROSCOPE_CHANNEL_NAME)
    gyroScopeStreamHandler = com.simform.flutter_credit_card.StreamHandlerImpl(
            sensorsManager,
            Sensor.TYPE_GYROSCOPE,
    )
    gyroscopeChannel.setStreamHandler(gyroScopeStreamHandler)
  }

  private fun teardownEventChannels() {
    gyroscopeChannel.setStreamHandler(null)
    gyroScopeStreamHandler.onCancel(null)
  }

  private fun setupMethodChannel(context: Context, messenger: BinaryMessenger) {
    methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
    methodChannel.setMethodCallHandler { call, result ->
      if (call.method == "isGyroscopeAvailable") {
        val packageManager: PackageManager = context.packageManager
        val gyroExists =
                packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_GYROSCOPE)
        result.success(gyroExists)
      }
    }
  }

  private fun teardownMethodChannel() {
    methodChannel.setMethodCallHandler(null)
  }

  companion object {
    private const val GYROSCOPE_CHANNEL_NAME = "com.simform.flutter_credit_card/gyroscope"
    private const val METHOD_CHANNEL_NAME = "com.simform.flutter_credit_card"
    private const val DEFAULT_UPDATE_INTERVAL = SensorManager.SENSOR_DELAY_NORMAL
  }
}
