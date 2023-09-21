import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../floating_animation/floating_event.dart';
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

  /// Denotes gyroscope feature availability.
  bool get isGyroscopeAvailable => false;

  /// The stream having gyroscope data events, if available.
  Stream<FloatingEvent>? get floatingStream => null;

  /// Initializes the method and event channels.
  Future<void> initialize() async => throw UnimplementedError();

  /// Initiates the gyroscope data events.
  Future<void> initiateEvents() async => throw UnimplementedError();

  /// Cancels the gyroscope data events.
  Future<void> cancelEvents() async => throw UnimplementedError();

  /// Disposes the method and event channels.
  Future<void> dispose() async => throw UnimplementedError();
}
