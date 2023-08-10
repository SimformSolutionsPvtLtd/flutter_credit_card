import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/flutter_credit_card_platform_interface.dart';
import 'package:flutter_credit_card/flutter_credit_card_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCreditCardPlatform
    with MockPlatformInterfaceMixin
    implements FlutterCreditCardPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterCreditCardPlatform initialPlatform = FlutterCreditCardPlatform.instance;

  test('$MethodChannelFlutterCreditCard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterCreditCard>());
  });

  test('getPlatformVersion', () async {
    FlutterCreditCard flutterCreditCardPlugin = FlutterCreditCard();
    MockFlutterCreditCardPlatform fakePlatform = MockFlutterCreditCardPlatform();
    FlutterCreditCardPlatform.instance = fakePlatform;

    expect(await flutterCreditCardPlugin.getPlatformVersion(), '42');
  });
}
