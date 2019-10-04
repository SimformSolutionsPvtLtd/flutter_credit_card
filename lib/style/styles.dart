import 'dart:math';
import 'package:flutter/material.dart';

TextStyle textCardStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontFamily: 'halter',
  package: 'flutter_credit_card',
);

int _defaultCardBgColor = 0xff1b447b;

LinearGradient cardGradient({Color color}) {
  final Color _color = color == null ? Color(_defaultCardBgColor) : color;

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
