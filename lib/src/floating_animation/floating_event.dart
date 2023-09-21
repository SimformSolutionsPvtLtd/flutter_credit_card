import '../utils/enumerations.dart';

class FloatingEvent {
  const FloatingEvent({
    required this.type,
    this.x = 0,
    this.y = 0,
    this.z = 0,
  });

  /// The event's [x], [y] and [z] values.
  ///
  /// [FloatingType.gyroscope] events : the [x], [y] and [z] values represent the rotation rate angle in radians, each event
  /// being relative to the previous one.
  ///
  /// [FloatingType.pointer] events : the [x] and [y] values represent the pointer's position in logical pixels, each event
  /// being an absolute value. [z] always equals zero.
  final double x, y, z;

  /// The [type] of motion described by this event.
  ///
  /// Indicates whether the event's coordinates describe a relative motion (gyroscope) or the absolute coordinate
  /// inside the widget (pointer) events.
  final FloatingType type;
}
