import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_credit_card_method_channel.dart';

abstract class FlutterCreditCardPlatform extends PlatformInterface {
  /// Constructs a FlutterCreditCardPlatform.
  FlutterCreditCardPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCreditCardPlatform _instance = MethodChannelFlutterCreditCard();

  /// The default instance of [FlutterCreditCardPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCreditCard].
  static FlutterCreditCardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCreditCardPlatform] when
  /// they register themselves.
  static set instance(FlutterCreditCardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
