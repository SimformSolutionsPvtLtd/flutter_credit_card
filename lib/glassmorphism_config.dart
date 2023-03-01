import 'package:flutter/material.dart';

class Glassmorphism {
  /// A config class for glassmorphism effect.
  Glassmorphism({
    required this.blurX,
    required this.blurY,
    required this.gradient,
  });

  /// Default config for glassmorphism effect.
  factory Glassmorphism.defaultConfig() {
    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Colors.grey.withAlpha(20),
        Colors.grey.withAlpha(20),
      ],
      stops: const <double>[
        0.3,
        0,
      ],
    );
    return Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient);
  }

  /// The sigmaX value for glassmorphism effect.
  final double blurX;

  /// The sigmaY value for glassmorphism effect.
  final double blurY;

  /// Gradient for the glassmorphism effect.
  final Gradient gradient;
}
