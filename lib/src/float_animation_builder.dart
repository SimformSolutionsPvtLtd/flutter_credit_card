import 'package:flutter/material.dart';

import 'floating_animation/floating_event.dart';
import 'utils/typedefs.dart';

class FloatAnimationBuilder extends StatelessWidget {
  const FloatAnimationBuilder({
    required this.isEnabled,
    required this.stream,
    required this.onEvent,
    required this.child,
    super.key,
  });

  final bool isEnabled;
  final Stream<FloatingEvent> stream;
  final FloatEventCallback onEvent;
  final WidgetCallback child;

  @override
  Widget build(BuildContext context) {
    return isEnabled
        ? StreamBuilder<FloatingEvent>(
            stream: stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<FloatingEvent> snapshot,
            ) =>
                Transform(
              transform: onEvent(snapshot.data),
              alignment: FractionalOffset.center,
              child: child(),
            ),
          )
        : child();
  }
}
