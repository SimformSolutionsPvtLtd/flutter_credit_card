import 'package:flutter/material.dart';

class Glassmorphism {
  Glassmorphism(
      {required this.blurX, required this.blurY, required this.gradient});

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

  final double blurX;
  final double blurY;
  final Gradient gradient;
}
