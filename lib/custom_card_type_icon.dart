import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class CustomCardTypeIcon {
  CustomCardTypeIcon({
    required this.cardType,
    required this.cardImage,
  });

  CardType cardType;
  Widget cardImage;
}
