import 'package:flutter/material.dart';
import 'dart:math';

TextStyle textCardStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'halter',
  fontSize: 16,
  package: 'flutter_credit_card',
);

LinearGradient cardGradient({Color color}) {
  final Color _color = color == null ? cardBgColor : color;

  return LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: const <double>[0.1, 0.4, 0.7, 0.9],
    colors: <Color>[
      _color.withOpacity(1),
      _color.withOpacity(0.97),
      _color.withOpacity(0.90),
      _color.withOpacity(0.86),
    ],
  );
}

Color cardBgColor = const Color(0xff1b447b);

AnimationController animationController(
        {TickerProvider vsync, Duration duration}) =>
    AnimationController(
      duration: duration,
      vsync: vsync,
    );
Animation<double> frontRotation(AnimationController controller) =>
    TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
Animation<double> backRotation(AnimationController controller) =>
    TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
