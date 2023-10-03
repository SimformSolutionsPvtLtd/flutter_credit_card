import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '../floating_animation/floating_event.dart';
import 'flutter_credit_card_platform_interface.dart';

/// A web implementation of the FlutterCreditCardPlatform of the
/// FlutterCreditCard plugin.
class FlutterCreditCardWeb extends FlutterCreditCardPlatform {
  /// Constructs a FlutterCreditCardWeb
  FlutterCreditCardWeb();

  static void registerWith(Registrar registrar) {
    FlutterCreditCardPlatform.instance = FlutterCreditCardWeb();
  }

  @override
  bool get isGyroscopeAvailable => false;

  @override
  Stream<FloatingEvent>? get floatingStream => null;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> initiateEvents() async {}

  @override
  Future<void> cancelEvents() async {}

  @override
  Future<void> dispose() async {}
}
