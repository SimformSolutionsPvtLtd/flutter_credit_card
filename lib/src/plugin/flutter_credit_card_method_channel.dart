import 'dart:io';

import 'package:flutter/services.dart';

import '../floating_animation/floating_event.dart';
import '../utils/constants.dart';
import '../utils/enumerations.dart';
import 'flutter_credit_card_platform_interface.dart';

/// An implementation of [FlutterCreditCardPlatform] that uses method channels.
class MethodChannelFlutterCreditCard extends FlutterCreditCardPlatform {
  static EventChannel? _gyroscopeEventChannel;

  static MethodChannel? _methodChannel;

  static Stream<FloatingEvent>? _gyroscopeStream;

  static bool _isGyroscopeAvailable = false;

  @override
  bool get isGyroscopeAvailable => _isGyroscopeAvailable;

  @override
  Stream<FloatingEvent>? get floatingStream {
    try {
      _gyroscopeStream ??= _gyroscopeEventChannel
          ?.receiveBroadcastStream()
          .map<FloatingEvent>((dynamic event) {
        final List<double> list = event.cast<double>();
        return FloatingEvent(
          type: FloatingType.gyroscope,
          x: list.first,
          y: list[1],
          z: list[2],
        );
      });
      return _gyroscopeStream as Stream<FloatingEvent>;
    } catch (e) {
      // If a PlatformException is thrown, the plugin is not available on the
      // device.
      _isGyroscopeAvailable = false;
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    _methodChannel ??= const MethodChannel(AppConstants.gyroMethodChannelName);
    _gyroscopeEventChannel ??= const EventChannel(
      AppConstants.gyroEventChannelName,
    );

    if (Platform.isIOS || Platform.isAndroid) {
      await initiateEvents();
      _isGyroscopeAvailable = await _methodChannel!.invokeMethod<dynamic>(
            AppConstants.isGyroAvailableMethod,
          ) ??
          false;
    } else {
      // Other platforms should not use the gyroscope events.
      _isGyroscopeAvailable = false;
    }
  }

  @override
  Future<void> initiateEvents() async =>
      _methodChannel?.invokeMethod<dynamic>(AppConstants.initiateMethod);

  @override
  Future<void> cancelEvents() async {
    _gyroscopeStream = null;
    return _methodChannel?.invokeMethod<dynamic>(AppConstants.cancelMethod);
  }

  @override
  Future<void> dispose() async {
    _isGyroscopeAvailable = false;
    _gyroscopeEventChannel = null;
    await cancelEvents();
    _methodChannel = null;
  }
}
