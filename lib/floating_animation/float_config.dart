import 'dart:ui';

import '../constants.dart';

class FloatConfig {
  /// Configuration for making the card float as per the movement of device or
  /// mouse pointer.
  const FloatConfig({
    this.isGlareEnabled = true,
    this.isShadowEnabled = true,
    this.shadowConfig,
  });

  /// Preset configuration for the floating card animation.
  factory FloatConfig.preset() => FloatConfig(
        shadowConfig: FloatShadowConfig.preset(),
      );

  /// Denotes whether to add a glare - a shinning effect - over the card.
  final bool isGlareEnabled;

  /// Denotes whether to add a shadow beneath the card.
  final bool isShadowEnabled;

  /// The configuration for adding a shadow beneath the card.
  final FloatShadowConfig? shadowConfig;

  @override
  bool operator ==(Object other) {
    return other is FloatConfig &&
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

class FloatShadowConfig {
  /// Configuration for the shadow appearing beneath the card when floating
  /// animation is enabled via [FloatConfig].
  const FloatShadowConfig({
    required this.offset,
    required this.color,
    required this.blurRadius,
  });

  /// Preset configuration for the shadow appearing beneath the card.
  FloatShadowConfig.preset()
      : offset = const Offset(0, 8),
        blurRadius = AppConstants.minBlurRadius,
        color = AppConstants.defaultShadowColor
            .withOpacity(AppConstants.minShadowOpacity);

  /// The offset of shadow from the card.
  final Offset offset;
  final double blurRadius;
  final Color color;

  @override
  bool operator ==(Object other) {
    return other is FloatShadowConfig &&
        other.color == color &&
        other.blurRadius == blurRadius &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(offset, color, blurRadius);
}
