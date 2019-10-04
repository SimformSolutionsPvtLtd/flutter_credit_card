import 'package:flutter/material.dart';

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
