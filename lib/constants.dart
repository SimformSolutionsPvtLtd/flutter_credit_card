import 'dart:math';
import 'dart:ui';

class AppConstants {
  static const double webBreakPoint = 800;
  static const double creditCardAspectRatio = 0.5714;
  static const double creditCardPadding = 16;


  /// Color constants
  static const Color defaultGlareColor = Color(0xffFFFFFF),
      defaultShadowColor = Color(0xff000000);

  /// Default filter quality
  static const FilterQuality defaultFilterQuality = FilterQuality.high;

  /// Numeric constants
    double maxElevation = 100,

  /// Defaults
      defaultMaxAngle = pi / 10,

  /// Shadow-specific values
      minShadowOffset = 0,
      maxShadowOffset = 40,
      minShadowTopOffset = 5,
      maxShadowTopOffset = 45,
      minBlurRadius = 10,
      maxBlurRadius = 30,
      minShadowOpacity = 0.3,
      maxShadowOpacity = 0.2,

  /// Translation-specific values
      maxDistance = 75.0;

}
