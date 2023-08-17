import 'package:flutter/material.dart';
import 'package:flutter_credit_card/constants.dart';
import 'package:flutter_credit_card/floating_card_setup/floating_controller.dart';


class GlareEffectWidget extends StatelessWidget {
  const GlareEffectWidget({
    super.key,
    required this.child,
    this.glarePosition,
    this.controller,
    this.border,
  });

  final Widget child;
  final double? glarePosition;
  final BoxBorder? border;
  final FloatingController? controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child,
        if (controller != null && glarePosition != null)
          Positioned.fill(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                border: border,
                gradient: LinearGradient(
                  tileMode: TileMode.clamp,
                  colors: <Color>[
                    AppConstants.defaultGlareColor.withOpacity(0.1),
                    AppConstants.defaultGlareColor.withOpacity(0.07),
                    AppConstants.defaultGlareColor.withOpacity(0.05),
                  ],
                  stops: const <double>[
                    0.1,
                    0.3,
                    0.6,
                  ],
                  transform: GradientRotation(glarePosition!),
                ),
              ),
            ),
          )
      ],
    );
  }
}
