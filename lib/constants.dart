import 'dart:math';
import 'dart:ui';

class AppConstants {
  static const double floatWebBreakPoint = 650;
  static const double creditCardAspectRatio = 0.5714;
  static const double creditCardPadding = 16;

  static const double minRestBackVel = 0.01;
  static const double maxRestBackVel = 0.05;
  static const double defaultRestBackVel = 0.8;

  static const Duration fps60 = Duration(microseconds: 16666);
  static const Duration fps60Offset = Duration(microseconds: 16667);

  /// Color constants
  static const Color defaultGlareColor = Color(0xffFFFFFF);
  static const Color floatingShadowColor = Color(0x4D000000);

  static const double defaultMaximumAngle = pi / 10;
  static const double minBlurRadius = 10;

  /// Gyroscope channel constants
  static const String gyroMethodChannelName = 'com.simform.flutter_credit_card';
  static const String gyroEventChannelName =
      'com.simform.flutter_credit_card/gyroscope';
  static const String isGyroAvailableMethod = 'isGyroscopeAvailable';
  static const String initiateMethod = 'initiateEvents';
  static const String cancelMethod = 'cancelEvents';
}
