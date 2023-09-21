import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/enumerations.dart';
import 'floating_event.dart';

class CursorListener extends StatefulWidget {
  /// This widget listens cursor entry and exit while hovering on the card
  const CursorListener({
    required this.onPositionChange,
    required this.height,
    required this.width,
    required this.padding,
    super.key,
  });

  /// Any padding applied to the area where the cursor movement is to be
  /// detected.
  final double padding;

  /// The height of the area where the cursor movement is to be detected.
  final double height;

  /// The width of the area where the cursor movement is to be detected.
  final double width;

  ///This called when a pointer event is received.
  final ValueChanged<FloatingEvent> onPositionChange;

  @override
  State<CursorListener> createState() => _CursorListenerState();
}

class _CursorListenerState extends State<CursorListener> {
  /// A value used for deltas and throttling
  Offset lastOffset = Offset.zero;

  /// A value used for deltas and throttling
  DateTime lastPointerEvent = DateTime.now();

  /// When idle, the intensity factor is 0. When the pointer enters, it
  /// progressively animates to 1.
  double intensityFactor = 0;

  /// A timer that progressively increases or decreases the intensity factor.
  Timer? velocityTimer;

  late double surroundedPadding = widget.padding * 2;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) => _onCursorEnter(),
      onExit: (_) => _onCursorExit(),
      onHover: (PointerHoverEvent details) {
        _onCursorMove(details.localPosition);
      },
    );
  }

  @override
  void dispose() {
    velocityTimer?.cancel();
    super.dispose();
  }

  void _onCursorMove(Offset position) {
    if (DateTime.now().difference(lastPointerEvent) < AppConstants.fps60) {
      /// Drop event since it occurs too early.
      return;
    }

    double x = 0.0;
    double y = 0.0;

    // Compute the fractional offset.
    x = (position.dy - (widget.height / 2)) / widget.height;
    y = -(position.dx - (widget.width / 2)) / widget.width;

    // Apply the intensity factor.
    x *= intensityFactor;
    y *= intensityFactor;

    // Calculate the maximum allowable offset while staying within the
    // screen bounds when the card widget is larger than
    // [AppConstants.webBreakPoint].
    if (widget.width > AppConstants.floatWebBreakPoint) {
      try {
        final double clampingFactor = surroundedPadding / widget.height;

        if (!clampingFactor.isNaN && !clampingFactor.isInfinite) {
          // Clamp the x and y values to stay within screen bounds.
          x = x.clamp(-clampingFactor, clampingFactor);
          y = y.clamp(-clampingFactor, clampingFactor);
        }
      } catch (_) {
        // Ignore clamping if it causes an error.
      }
    }

    // Notify the position change.
    widget.onPositionChange(
      FloatingEvent(
        type: FloatingType.pointer,
        x: x,
        y: y,
      ),
    );

    // Store the previous values.
    lastPointerEvent = DateTime.now();
    lastOffset = Offset(position.dx, position.dy);
  }

  /// Animate the intensity factor to 1, to smoothly get to the pointer's
  /// position.
  Future<void> _onCursorEnter() async {
    _cancelVelocityTimer();

    velocityTimer = Timer.periodic(
      AppConstants.fps60Offset,
      (_) {
        if (intensityFactor < 1) {
          if (intensityFactor <= 0.05) {
            intensityFactor = 0.05;
          }
          intensityFactor = min(1, intensityFactor * 1.2);
          _onCursorMove(lastOffset);
        } else {
          _cancelVelocityTimer();
        }
      },
    );
  }

  /// Animate the intensity factor to 0, to smoothly get back to the initial
  /// position.
  Future<void> _onCursorExit() async {
    _cancelVelocityTimer();

    velocityTimer = Timer.periodic(
      AppConstants.fps60Offset,
      (_) {
        if (intensityFactor > 0.05) {
          intensityFactor = max(0, intensityFactor * 0.95);
          _onCursorMove(lastOffset);
        } else {
          _cancelVelocityTimer();
        }
      },
    );
  }

  /// Cancels the velocity timer.
  void _cancelVelocityTimer() {
    velocityTimer?.cancel();
    velocityTimer = null;
  }
}
