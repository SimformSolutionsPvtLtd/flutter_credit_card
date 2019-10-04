import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/model/card_patterns.dart';
import 'package:http/http.dart' as http;

Size size(BuildContext context) => MediaQuery.of(context).size;
Orientation orientation(BuildContext context) =>
    MediaQuery.of(context).orientation;

void getCardTypeIcon(String cardNumber) {
  getCardBin(cardNumber);

  // Widget icon;
  // switch (detectCCType(cardNumber)) {
  //   case CardType.visa:
  //     icon = Image.asset(
  //       'icons/visa.png',
  //       height: 48,
  //       width: 48,
  //       package: 'flutter_credit_card',
  //     );

  //     break;

  //   case CardType.americanExpress:
  //     icon = Image.asset(
  //       'icons/amex.png',
  //       height: 48,
  //       width: 48,
  //       package: 'flutter_credit_card',
  //     );

  //     break;

  //   case CardType.mastercard:
  //     icon = Image.asset(
  //       'icons/mastercard.png',
  //       height: 48,
  //       width: 48,
  //       package: 'flutter_credit_card',
  //     );

  //     break;

  //   case CardType.discover:
  //     icon = Image.asset(
  //       'icons/discover.png',
  //       height: 48,
  //       width: 48,
  //       package: 'flutter_credit_card',
  //     );

  //     break;

  //   default:
  //     icon = Container(
  //       height: 48,
  //       width: 48,
  //     );

  //     break;
  // }

  // return icon;
}

CardType detectCCType(String cardNumber) {
  //Default card type is other
  CardType cardType = CardType.otherBrand;

  if (cardNumber.isEmpty) {
    return cardType;
  }

  cardNumPatterns.forEach(
    (CardType type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        // Remove any spaces
        String ccPatternStr = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
        final int rangeLen = patternRange[0].length;
        // Trim the Credit Card number string to match the pattern prefix length
        if (rangeLen < cardNumber.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (patternRange.length > 1) {
          // Convert the prefix range into numbers then make sure the
          // Credit Card num is in the pattern range.
          // Because Strings don't have '>=' type operators
          final int ccPrefixAsInt = int.parse(ccPatternStr);
          final int startPatternPrefixAsInt = int.parse(patternRange[0]);
          final int endPatternPrefixAsInt = int.parse(patternRange[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt &&
              ccPrefixAsInt <= endPatternPrefixAsInt) {
            // Found a match
            cardType = type;
            break;
          }
        } else {
          // Just compare the single pattern prefix with the Credit Card prefix
          if (ccPatternStr == patternRange[0]) {
            // Found a match
            cardType = type;
            break;
          }
        }
      }
    },
  );

  return cardType;
}

Future<Widget> getCardBin(String cardNumber) async {
  if (cardNumber.length >= 6) {
    try {
      dynamic result =
          await http.read('https://binlist.io/lookup/' + cardNumber);
      print(jsonDecode(result)['scheme']);
      return Container();
    } catch (e) {
      print(e);
      print('did not find the card flag');
    }
  }

  return Container();
}
