import 'dart:async';
import 'dart:developer' as developer;
import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:js_util';

import 'package:flutter_credit_card/floating_card_setup/floating_event.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_credit_card_platform_interface.dart';

@JS()
external dynamic get evaluatePermission;

/// A web implementation of the FlutterCreditCardPlatform of the FlutterCreditCard plugin.
class FlutterCreditCardWeb extends FlutterCreditCardPlatform {
  /// Constructs a FlutterCreditCardWeb
  FlutterCreditCardWeb();

  static void registerWith(Registrar registrar) {
    FlutterCreditCardPlatform.instance = FlutterCreditCardWeb();
  }

  static bool _isGyroscopeAvailable = false;

  @override
  bool get isGyroscopeAvailable => _isGyroscopeAvailable;


  void _featureDetected(
    Function initSensor, {
    String? apiName,
    String? permissionName,
    Function? onError,
  }) {
    try {
      initSensor();
    } catch (error) {
      if (onError != null) {
        onError();
      }

      /// Handle construction errors.
      ///
      /// If a feature policy blocks use of a feature it is because your code
      /// is inconsistent with the policies set on your server.
      /// This is not something that would ever be shown to a user.
      /// See Feature-Policy for implementation instructions in the browsers.
      if (error.toString().contains('SecurityError')) {
        /// See the note above about feature policy.
        developer.log('$apiName construction was blocked by a feature policy.',
            error: error);

        /// if this feature is not supported or Flag is not enabled yet!
      } else if (error.toString().contains('ReferenceError')) {
        developer.log('$apiName is not supported by the User Agent.',
            error: error);

        /// if this is unknown error, rethrow it
      } else {
        developer.log('Unknown error happened, rethrowing.');
        rethrow;
      }
    }
  }

  DateTime lastFloatingPoint = DateTime.now();

  StreamController<FloatingEvent>? _gyroscopeStreamController;
  Stream<FloatingEvent>? _gyroscopeStream;

  @override
  Stream<FloatingEvent>? get floatingStream {
    if (_gyroscopeStreamController == null) {
      _gyroscopeStreamController = StreamController<FloatingEvent>();

      // TODO(Kavan): handle IOS web support
      /// We have not added device motion stream for IOS
      /// Facing issue while calling native method of Gyroscope to check whether
      /// it exists or not : refer Motion Plugin's scripts.dart
      _featureDetected(
        () {
          final html.Gyroscope gyroscope = html.Gyroscope();
          setProperty(
            gyroscope,
            'onreading',
            allowInterop(
              (dynamic data) {
                if (gyroscope.x != null ||
                    gyroscope.y != null ||
                    gyroscope.z != null) {
                  _isGyroscopeAvailable = true;
                  Timer.periodic(const Duration(microseconds: 16666),
                      (Timer timer) {
                    _gyroscopeStreamController!.add(
                      FloatingEvent(
                        type: FloatingType.gyroscope,
                        x: gyroscope.x! * 5 as double,
                        y: gyroscope.y! * 5 as double,
                        z: gyroscope.z! * 5 as double,
                      ),
                    );
                  });
                } else {
                  _isGyroscopeAvailable = false;
                }
              },
            ),
          );

          gyroscope.start();
        },
        apiName: 'Gyroscope()',
        permissionName: 'gyroscope',
        onError: () {
          html.window.console
              .warn('Error: Gyroscope() is not supported by the User Agent.');
          _gyroscopeStreamController!
              .add(const FloatingEvent.zero(type: FloatingType.gyroscope));
        },
      );

      _gyroscopeStream = _gyroscopeStreamController!.stream.asBroadcastStream();
    }

    return _gyroscopeStream;
  }

  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<bool> requestPermission() async {
    // TODO(kavan): Add request permission for IOS Web
    return false;
  }
}
