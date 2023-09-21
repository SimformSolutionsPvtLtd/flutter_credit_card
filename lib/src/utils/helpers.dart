import 'package:flutter/widgets.dart';

import '../models/custom_card_type_icon.dart';
import 'constants.dart';
import 'enumerations.dart';

/// Uses the predefined prefixes from [AppConstants.cardNumPatterns] to match
/// with the prefix of the [cardNumber] in order to detect the [CardType].
/// Defaults to [CardType.otherBrand] if unable to detect a type.
CardType detectCCType(String cardNumber) {
  if (cardNumber.isEmpty) {
    return CardType.otherBrand;
  }

  // Remove any spaces
  cardNumber = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');

  final int firstDigit = int.parse(
    cardNumber.length <= 1 ? cardNumber : cardNumber.substring(0, 1),
  );

  if (!AppConstants.cardNumPatterns.containsKey(firstDigit)) {
    return CardType.otherBrand;
  }

  final Map<List<int?>, CardType> cardNumPatternSubMap =
      AppConstants.cardNumPatterns[firstDigit]!;

  final int ccPatternNum = int.parse(cardNumber);

  for (final List<int?> range in cardNumPatternSubMap.keys) {
    int subPatternNum = ccPatternNum;

    if (range.length != 2 || range.first == null) {
      continue;
    }

    final int start = range.first!;
    final int? end = range.last;

    // Adjust the cardNumber prefix as per the length of start prefix range.
    final int startLen = start.toString().length;
    if (startLen < cardNumber.length) {
      subPatternNum = int.parse(cardNumber.substring(0, startLen));
    }

    if ((end == null && subPatternNum == start) ||
        ((subPatternNum <= (end ?? -double.maxFinite)) &&
            subPatternNum >= start)) {
      return cardNumPatternSubMap[range]!;
    }
  }

  return CardType.otherBrand;
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
