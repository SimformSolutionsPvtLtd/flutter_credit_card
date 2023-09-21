import 'package:flutter/material.dart';

import '../utils/constants.dart';

class GlareEffectWidget extends StatelessWidget {
  const GlareEffectWidget({
    required this.child,
    this.glarePosition,
    this.border,
    super.key,
  });

  final Widget child;
  final BoxBorder? border;
  final double? glarePosition;

  static final List<Color> _glareGradientColors = <Color>[
    AppConstants.defaultGlareColor.withOpacity(0.1),
    AppConstants.defaultGlareColor.withOpacity(0.07),
    AppConstants.defaultGlareColor.withOpacity(0.05),
  ];

  static const List<double> _gradientStop = <double>[0.1, 0.3, 0.6];

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child,
        if (glarePosition != null)
          Positioned.fill(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                border: border,
                gradient: LinearGradient(
                  tileMode: TileMode.clamp,
                  colors: _glareGradientColors,
                  stops: _gradientStop,
                  transform: GradientRotation(glarePosition!),
                ),
              ),
            ),
          )
      ],
    );
  }
}
