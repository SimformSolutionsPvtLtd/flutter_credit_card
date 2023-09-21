import 'package:flutter/widgets.dart';

import '../models/custom_card_type_icon.dart';
import 'constants.dart';
import 'enumerations.dart';

/// This function determines the Credit Card type based on the cardPatterns
/// and returns it.
CardType detectCCType(String cardNumber) {
  //Default card type is other
  CardType cardType = CardType.otherBrand;

  if (cardNumber.isEmpty) {
    return cardType;
  }

  AppConstants.cardNumPatterns.forEach(
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

/// Returns the icon for the card type if detected else will return a
/// [SizedBox].
Widget getCardTypeImage({
  required List<CustomCardTypeIcon> customIcons,
  CardType? cardType,
}) {
  const Widget blankSpace =
      SizedBox.square(dimension: AppConstants.creditCardIconSize);

  if (cardType == null) {
    return blankSpace;
  }

  return customIcons.firstWhere(
    (CustomCardTypeIcon element) => element.cardType == cardType,
    orElse: () {
      final bool isKnownCardType =
          AppConstants.cardTypeIconAsset.containsKey(cardType);

      return CustomCardTypeIcon(
        cardType: isKnownCardType ? cardType : CardType.otherBrand,
        cardImage: isKnownCardType
            ? Image.asset(
                AppConstants.cardTypeIconAsset[cardType]!,
                height: AppConstants.creditCardIconSize,
                width: AppConstants.creditCardIconSize,
                package: AppConstants.packageName,
              )
            : blankSpace,
      );
    },
  ).cardImage;
}
