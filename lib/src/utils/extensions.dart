import 'package:flutter/widgets.dart';

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  bool get isNotNullAndNotEmpty => this?.isNotEmpty ?? false;
}

extension OrientationExtension on Orientation {
  bool get isPortrait => this == Orientation.portrait;

  bool get isLandscape => this == Orientation.landscape;
}

extension ColorExtension on Color {
  /// Converts opacity value to color with alpha
  /// This avoids using the deprecated overlayOpacity directly
  Color reduceOpacity(double opacity) => withAlpha((opacity * 255).round());
}
