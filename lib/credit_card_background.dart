import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'glassmorphism_config.dart';

class CardBackground extends StatelessWidget {
  const CardBackground({
    Key? key,
    required this.backgroundGradientColor,
    this.backgroundImage,
    this.backgroundNetworkImage,
    required this.child,
    this.glassmorphismConfig,
  })  : assert(
            (backgroundImage == null && backgroundNetworkImage == null) ||
                (backgroundImage == null && backgroundNetworkImage != null) ||
                (backgroundImage != null && backgroundNetworkImage == null),
            "You can't use network image & asset image at same time for card background"),
        super(key: key);

  final String? backgroundImage;
  final String? backgroundNetworkImage;
  final Widget child;
  final Gradient backgroundGradientColor;
  final Glassmorphism? glassmorphismConfig;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: glassmorphismConfig != null
                  ? glassmorphismConfig!.gradient
                  : backgroundGradientColor,
              image: backgroundImage != null && backgroundImage!.isNotEmpty
                  ? DecorationImage(
                      image: ExactAssetImage(
                        backgroundImage!,
                      ),
                      fit: BoxFit.fill,
                    )
                  : backgroundNetworkImage != null &&
                          backgroundNetworkImage!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(
                            backgroundNetworkImage!,
                          ),
                          fit: BoxFit.fill,
                        )
                      : null,
            ),
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
          if (glassmorphismConfig != null) _GlassmorphicBorder(),
        ],
      );
    });
  }
}

class _GlassmorphicBorder extends StatefulWidget {
  const _GlassmorphicBorder();

  @override
  State<_GlassmorphicBorder> createState() => _GlassmorphicBorderState();
}

class _GlassmorphicBorderState extends State<_GlassmorphicBorder> {
  late final _GradientPainter _painter;

  @override
  void didChangeDependencies() {
    _painter = _GradientPainter(
        strokeWidth: 2,
        radius: 10,
        isDark: Theme.of(context).colorScheme.brightness == Brightness.dark);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      size: MediaQuery.of(context).size,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  _GradientPainter({
    required this.strokeWidth,
    required this.radius,
    required this.isDark,
  });

  final double radius;
  final double strokeWidth;
  final Paint paintObject = Paint();
  final Paint paintObject2 = Paint();
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final Color base = isDark ? Colors.white : Colors.black;
    final LinearGradient gradient = LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: <Color>[
          base.withAlpha(50),
          base.withAlpha(55),
          base.withAlpha(50),
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
