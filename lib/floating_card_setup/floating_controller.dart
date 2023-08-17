import 'dart:math';

import 'package:flutter_credit_card/constants.dart';

class FloatingController {
  /// A controller that holds the [Motion] widget's X and Y angles.
  FloatingController({
    this.floatingBack = 0.8,
    this.maximumAngle = pi / 10,
  });

  /// Floating back will be use when card comes back to default position
  /// the velocity will be determine by [floatingBack] value
  double? floatingBack;

  /// The actual floating back factor used by the widget.
  ///
  /// Computed from the [floatingBack] value which lerps from 0 to 1 between [minfloatingBack] and [maxfloatingBack].
  double get floatingBackFactor => floatingBack != null
      ? 1 -
          (AppConstants.minfloatingBack +
              (floatingBack! *
                  (AppConstants.maxfloatingBack -
                      AppConstants.minfloatingBack)))
      : 1;

  /// maximum angle at which floating animation can move
  double maximumAngle;

  /// x,y value for gyroscope and mouse pointer data
  double x = 0, y = 0;

  static final FloatingController defaultController = FloatingController();

  /// let x and y value can only extend to specified angle
  void limitTheAngle() {
    x = min(maximumAngle / 2, max(-maximumAngle / 2, x));
    y = min(maximumAngle / 2, max(-maximumAngle / 2, y));
  }
}
