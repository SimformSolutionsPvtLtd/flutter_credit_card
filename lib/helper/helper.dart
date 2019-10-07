import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

Size size(BuildContext context) => MediaQuery.of(context).size;
Orientation orientation(BuildContext context) =>
    MediaQuery.of(context).orientation;

Future<Widget> getCardBin(String cardNumber) async {
  if (cardNumber.length >= 6) {
    try {
      final dynamic result = await http.read('https://binlist.io/lookup/' +
          cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), ''));

      print(jsonDecode(result)['scheme']);

      if (flags[jsonDecode(result)['scheme']] != null) {
        return flags[jsonDecode(result)['scheme']];
      } else {
        return Container();
      }
    } catch (e) {
      print(e);
      print('did not find the card flag');
    }
  } else {
    print('Find but not all');
    return Container();
  }
  print('Dont find');
  return Container();
}

Map<String, dynamic> flags = <String, dynamic>{
  'MASTERCARD':
      SvgPicture.asset('packages/flutter_credit_card/assets/master.svg'),
  'VISA': SvgPicture.asset('packages/flutter_credit_card/assets/visa.svg'),
  'ELO': SvgPicture.asset('packages/flutter_credit_card/assets/elo.svg'),
  'JCB': SvgPicture.asset('packages/flutter_credit_card/assets/jcb.svg'),
  'DISCOVER':
      SvgPicture.asset('packages/flutter_credit_card/assets/discover.svg'),
  'DINERS CLUB':
      SvgPicture.asset('packages/flutter_credit_card/assets/diners.svg'),
  'aura': SvgPicture.asset('packages/flutter_credit_card/assets/aura.svg'),
  'AMERICAN EXPRESS':
      SvgPicture.asset('packages/flutter_credit_card/assets/amex.svg'),
  'HIPERCARD':
      SvgPicture.asset('packages/flutter_credit_card/assets/hipercard'),
};
