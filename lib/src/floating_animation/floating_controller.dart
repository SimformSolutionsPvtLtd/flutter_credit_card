import 'dart:math';

import 'package:flutter/rendering.dart';

import '../utils/constants.dart';
import 'floating_event.dart';

class FloatingController {
  /// Houses [x] and [y] angles, and the transformation logic for the
  /// floating effect.
  FloatingController({
    required this.maximumAngle,
    this.restBackVelocity,
    this.isGyroscopeAvailable = false,
  });

  FloatingController.predefined()
      : restBackVelocity = AppConstants.defaultRestBackVel,
        maximumAngle = AppConstants.defaultMaximumAngle,
        isGyroscopeAvailable = false;

  bool isGyroscopeAvailable;

  /// The maximum floating animation moving angle.
  double maximumAngle;

  /// Represents the x value for gyroscope and mouse pointer data.
  double x = 0;

  /// Represents the y value for gyroscope and mouse pointer data.
  double y = 0;

  /// Determines the velocity when the card rests back to default position.
  double? restBackVelocity;

  /// The actual resting back factor used by the widget.
  ///
  /// Computed from the [restBackVelocity] value which lerps from 0 to 1 between
  /// [minRestBackVel] and [maxRestBackVel].
  double get restBackFactor {
    if (restBackVelocity == null) {
      return 1;
    } else {
      const double restBackVelRange =
          AppConstants.maxRestBackVel - AppConstants.minRestBackVel;
      final double adjusted =
          AppConstants.minRestBackVel + (restBackVelocity! * restBackVelRange);
      return 1 - adjusted;
    }
  }

  /// Restricts [x] and [y] values to extend within the limit of the
  /// [maximumAngle] only.
  void boundAngle() {
    x = min(maximumAngle / 2, max(-maximumAngle / 2, x));
    y = min(maximumAngle / 2, max(-maximumAngle / 2, y));
  }

  /// Transforms the [x] and [y] angles by performing operations on the angles
  /// received from the [event].
  Matrix4 transform(
    FloatingEvent? event, {
    /// Denotes whether to avoid applying any transformation.
    bool shouldAvoid = false,
  }) {
    final Matrix4 matrix = Matrix4.identity()..setEntry(3, 2, 0.001);

    if (shouldAvoid || event == null) {
      return matrix;
    }

    if (isGyroscopeAvailable) {
      x += event.x * 0.016;
      y -= event.y * 0.016;

      boundAngle();

      // Apply the velocity to float the card.
      x *= restBackFactor;
      y *= restBackFactor;
    } else {
      x = event.x * 0.2;
      y = event.y * 0.2;
    }

    // Rotate the matrix by the resulting x and y values.
    matrix
      ..rotateX(x)
      ..rotateY(y)
      ..translate(y * -90, x * 45);

    return matrix;
  }
}
