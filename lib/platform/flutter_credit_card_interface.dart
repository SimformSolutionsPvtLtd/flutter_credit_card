import 'package:flutter/services.dart';

class FlutterCreditCardInterface {
  FlutterCreditCardInterface._();

  static FlutterCreditCardInterface instance = FlutterCreditCardInterface._();

  static const MethodChannel _methodChannel =
      MethodChannel('com.simform.flutter_credit_card/methods');

  Future<void> checkPermission() async {
    final bool? hasPermission =
        await _methodChannel.invokeMethod<bool?>('checkPermission');
    print(hasPermission);
  }
}

