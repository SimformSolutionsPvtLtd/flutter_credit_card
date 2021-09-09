import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'constants.dart';
import 'glassmorphism_config.dart';

class CardBackground extends StatelessWidget {
  const CardBackground({
    Key? key,
    required this.backgroundGradientColor,
    required this.backgroundImage,
    required this.child,
    this.width,
    this.height,
    this.glassmorphismConfig,
  }) : super(key: key);

  final String? backgroundImage;
  final Widget child;
  final Gradient backgroundGradientColor;
  final Glassmorphism? glassmorphismConfig;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final double screenWidth = constraints.maxWidth.isInfinite
          ? MediaQuery.of(context).size.width
          : constraints.maxWidth;
      final double screenHeight = MediaQuery.of(context).size.height;
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(AppConstants.creditCardPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: glassmorphismConfig != null
                  ? glassmorphismConfig!.gradient
                  : backgroundGradientColor,
              image: backgroundImage != null
                  ? DecorationImage(
                      image: ExactAssetImage(
                        backgroundImage!,
                      ),
                      fit: BoxFit.fill,
                    )
                  : null,
            ),
            width: width ?? screenWidth,
            height: height ??
                (orientation == Orientation.portrait
                    ? (((width ?? screenWidth) -
                            (AppConstants.creditCardPadding * 2)) *
                        AppConstants.creditCardAspectRatio)
                    : screenHeight / 2),
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                child: glassmorphismConfig != null
                    ? BackdropFilter(
                        filter: ui.ImageFilter.blur(
                          sigmaX: glassmorphismConfig?.blurX ?? 0.0,
                          sigmaY: glassmorphismConfig?.blurY ?? 0.0,
                        ),
                        child: child,
                      )
                    : child,
              ),
            ),
          ),
          if (glassmorphismConfig != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: _GlassmorphicBorder(
                width: width ?? screenWidth,
                height: height ??
                    (orientation == Orientation.portrait
                        ? ((screenWidth - 32) * 0.5714)
                        : screenHeight / 2),
              ),
            ),
        ],
      );
    });
  }
}

class _GlassmorphicBorder extends StatelessWidget {
  _GlassmorphicBorder({
    required this.height,
    required this.width,
  }) : _painter = _GradientPainter(strokeWidth: 2, radius: 10);
  final _GradientPainter _painter;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      size: MediaQuery.of(context).size,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: width,
        height: height,
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  _GradientPainter({required this.strokeWidth, required this.radius});

  final double radius;
  final double strokeWidth;
  final Paint paintObject = Paint();
  final Paint paintObject2 = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final LinearGradient gradient = LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: <Color>[
          Colors.white.withAlpha(50),
          Colors.white.withAlpha(55),
          Colors.white.withAlpha(50),
        ],
        stops: const <double>[
          0.06,
          0.95,
          1
        ]);
    final RRect innerRect2 = RRect.fromRectAndRadius(
        Rect.fromLTRB(strokeWidth, strokeWidth, size.width - strokeWidth,
            size.height - strokeWidth),
        Radius.circular(radius - strokeWidth));

    final RRect outerRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.width, size.height), Radius.circular(radius));
    paintObject.shader = gradient.createShader(Offset.zero & size);

    final Path outerRectPath = Path()..addRRect(outerRect);
    final Path innerRectPath2 = Path()..addRRect(innerRect2);
    canvas.drawPath(
        Path.combine(
            PathOperation.difference,
            outerRectPath,
            Path.combine(
                PathOperation.intersect, outerRectPath, innerRectPath2)),
        paintObject);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
