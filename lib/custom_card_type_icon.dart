import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

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
