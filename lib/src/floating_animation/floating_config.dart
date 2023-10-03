import 'dart:ui';

import '../utils/constants.dart';

class FloatingConfig {
  /// Configuration for making the card float as per the movement of device or
  /// mouse pointer.
  const FloatingConfig({
    this.isGlareEnabled = true,
    this.isShadowEnabled = true,
    this.shadowConfig = const FloatingShadowConfig(),
  });

  /// Denotes whether to add a glare - a shinning effect - over the card.
  final bool isGlareEnabled;

  /// Denotes whether to add a shadow beneath the card.
  final bool isShadowEnabled;

  /// The configuration for adding a shadow beneath the card.
  final FloatingShadowConfig shadowConfig;

  @override
  bool operator ==(Object other) {
    return other is FloatingConfig &&
        other.isGlareEnabled == isGlareEnabled &&
        other.isShadowEnabled == isShadowEnabled &&
        other.shadowConfig == shadowConfig;
  }

  @override
  int get hashCode => Object.hash(
        isGlareEnabled,
        isShadowEnabled,
        shadowConfig,
      );
}

class FloatingShadowConfig {
  /// Configuration for the shadow appearing beneath the card when floating
  /// animation is enabled via [FloatingConfig].
  const FloatingShadowConfig({
    this.offset = const Offset(0, 8),
    this.color = AppConstants.floatingShadowColor,
    this.blurRadius = AppConstants.minBlurRadius,
  });

  /// The offset of shadow from the card.
  final Offset offset;
  final double blurRadius;
  final Color color;

  @override
  bool operator ==(Object other) {
    return other is FloatingShadowConfig &&
        other.color == color &&
        other.blurRadius == blurRadius &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(offset, color, blurRadius);
}
