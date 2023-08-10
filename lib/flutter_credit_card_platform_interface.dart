import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'floating_card_setup/floating_event.dart';
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

  /// Detects if the platform is Safari Mobile (iOS or iPad).
  bool get isSafariMobile => false;

  /// Indicates whether the gradient is available.
  bool get isGradientOverlayAvailable => !isSafariMobile;

  /// Indicates whether the gyroscope is available.
  bool get isGyroscopeAvailable => false;

  /// Indicates whether a permission is required to access gyroscope data.
  bool get isPermissionRequired => false;

  /// Indicates whether the permission is granted.
  bool get isPermissionGranted => false;

  /// The gyroscope stream, if available.
  Stream<FloatingEvent>? get floatingStream => null;

  Future<void> initialize() async {
    throw UnimplementedError();
  }

  Future<bool> requestPermission() async {
    throw UnimplementedError();
  }
}
