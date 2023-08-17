import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/gestures/events.dart';

class CursorListener extends StatefulWidget {
  /// This widget listens cursor entry and exit while hovering on the card
  const CursorListener(
      {Key? key, required this.child, required this.onPositionChange})
      : super(key: key);
  final Widget child;

  ///This called when a pointer event is received.
  final Function(Offset newOffset) onPositionChange;

  @override
  State<CursorListener> createState() => _CursorListenerState();
}

class _CursorListenerState extends State<CursorListener> {
  final GlobalKey<State<StatefulWidget>> mouseCursorKey = GlobalKey();

  /// A track of the latest size returned by the widget's layout builder.
  Size? childSize;

  /// A value used for deltas and throttling
  Offset lastOffset = Offset.zero;

  /// A value used for deltas and throttling
  DateTime lastPointerEvent = DateTime.now();

  /// When idle, the intensity factor is 0. When the pointer enters, it progressively animates to 1.
  double intensityFactor = 0;

  double get width => childSize?.width ?? 1;

  double get height => childSize?.height ?? 1;

  /// A timer that progressively increases or decreases the intensity factor.
  Timer? velocityTimer;

  @override
  void dispose() {
    velocityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          widget.child,
          Positioned.fill(
            child: LayoutBuilder(
              builder: (BuildContext ctx, BoxConstraints constraints) {
                childSize = Size(constraints.maxWidth, constraints.maxHeight);
                return Listener(
                  onPointerHover: (PointerHoverEvent details) {
                    _onPointerMove(position: details.localPosition);
                  },
                  onPointerMove: (PointerMoveEvent details) {
                    _onPointerMove(position: details.localPosition);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: MouseRegion(
                    hitTestBehavior: HitTestBehavior.translucent,
                    key: mouseCursorKey,
                    onExit: (PointerExitEvent details) {
                      _onPointerExit();
                    },
                    onEnter: (PointerEnterEvent details) {
                      _onPointerEnter();
                    },
                    child: Container(),
                  ),
                );
              },
            ),
          )
        ],
      );

  void _onPointerMove({required Offset position}) {
    if (DateTime.now().difference(lastPointerEvent) <
        const Duration(microseconds: 16666)) {
      /// Drop event since it occurs too early.
      return;
    }

    double x, y;

    // Compute the fractional offset.
    x = (position.dy - (height / 2)) / height;
    y = -(position.dx - (width / 2)) / width;

    // Apply the intensity factor.
    x *= intensityFactor;
    y *= intensityFactor;

    // Notify the position change.
    widget.onPositionChange(Offset(x, y));

    // Store the pass informations.
    lastPointerEvent = DateTime.now();
    lastOffset = Offset(position.dx, position.dy);
  }

  /// Animate the intensity factor to 1, to smoothly get to the pointer's position.
  Future<void> _onPointerEnter() async {
    _cancelVelocityTimer();

    velocityTimer =
        Timer.periodic(const Duration(microseconds: 1 + 16666), (Timer timer) {
      if (intensityFactor < 1) {
        if (intensityFactor <= 0.05) {
          intensityFactor = 0.05;
        }
        intensityFactor = min(1, intensityFactor * 1.2);
        _onPointerMove(position: lastOffset);
      } else {
        _cancelVelocityTimer();
      }
    });
  }

  /// Animate the intensity factor to 0, to smoothly get back to the initial position.
  Future<void> _onPointerExit() async {
    _cancelVelocityTimer();

    velocityTimer =
        Timer.periodic(const Duration(microseconds: 1 + 16666), (Timer timer) {
      if (intensityFactor > 0.05) {
        intensityFactor = max(0, intensityFactor * 0.95);
        _onPointerMove(position: lastOffset /*, isVelocity: true*/);
      } else {
        _cancelVelocityTimer();
      }
    });
  }

  /// Cancels the velocity timer.
  void _cancelVelocityTimer() {
    velocityTimer?.cancel();
    velocityTimer = null;
  }
}
