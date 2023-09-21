import 'package:flutter/widgets.dart';

import '../utils/enumerations.dart';

class CustomCardTypeIcon {
  /// A model class to update card image with user defined widget for the
  /// [CardType].
  CustomCardTypeIcon({
    required this.cardType,
    required this.cardImage,
  });

  /// Specify type of the card available in the parameter of enum.
  CardType cardType;

  /// Showcasing widget for specified card type.
  Widget cardImage;
}
