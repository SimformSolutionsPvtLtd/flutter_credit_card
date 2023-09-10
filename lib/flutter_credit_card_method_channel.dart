import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_credit_card_platform_interface.dart';

/// An implementation of [FlutterCreditCardPlatform] that uses method channels.
class MethodChannelFlutterCreditCard extends FlutterCreditCardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_credit_card');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
