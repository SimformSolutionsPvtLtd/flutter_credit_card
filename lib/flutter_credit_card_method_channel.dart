import 'dart:io';

import 'package:flutter/services.dart';

import 'floating_card_setup/floating_event.dart';
import 'flutter_credit_card_platform_interface.dart';

/// An implementation of [FlutterCreditCardPlatform] that uses method channels.
class MethodChannelFlutterCreditCard extends FlutterCreditCardPlatform {
  static EventChannel? _gyroscopeEventChannel;

  static MethodChannel? _methodChannel;

  static Stream<FloatingEvent>? _gyroscopeStream;

  @override
  bool get isSafariMobile => false;

  static bool _isGyroscopeAvailable = true;

  @override
  bool get isGyroscopeAvailable => _isGyroscopeAvailable;

  @override
  bool get isPermissionGranted => false;

  @override
  bool get isPermissionRequired => false;

  @override
  Stream<FloatingEvent>? get floatingStream {
    try {
      _gyroscopeStream ??= _gyroscopeEventChannel
          ?.receiveBroadcastStream()
          .map<FloatingEvent>((dynamic event) {
        final List<double> list = event.cast<double>();
        return FloatingEvent(
            type: FloatingType.gyroscope, x: list[0], y: list[1], z: list[2]);
      });
      _gyroscopeStream?.listen((FloatingEvent event) {});
      return _gyroscopeStream as Stream<FloatingEvent>;
    } catch (e) {
      // If a PlatformException is thrown, the plugin is not available on the device.
      _isGyroscopeAvailable = false;
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    if (Platform.isIOS || Platform.isAndroid) {
      _methodChannel ??= const MethodChannel('com.simform.flutter_credit_card');

      _isGyroscopeAvailable =
          await _methodChannel!.invokeMethod<dynamic>('isGyroscopeAvailable') ??
              false;

      _gyroscopeEventChannel ??=
      const EventChannel('com.simform.flutter_credit_card/gyroscope');

    } else if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      // Desktop platforms should not use the gyroscope events.
      _isGyroscopeAvailable = false;
    }

    return;
  }


  @override
  Future<bool> requestPermission() async => true;
}
