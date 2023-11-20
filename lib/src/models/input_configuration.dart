import 'package:flutter/material.dart';
import 'package:flutter_credit_card/src/utils/constants.dart';

class InputConfiguration {
  /// Provides [InputDecoration] and [TextStyle] to [CreditCardForm]'s [TextField].
  const InputConfiguration({
    this.cardHolderDecoration = const InputDecoration(
      labelText: AppConstants.cardHolder,
    ),
    this.cardNumberDecoration = const InputDecoration(
      labelText: AppConstants.cardNumber,
      hintText: AppConstants.sixteenX,
    ),
    this.expiryDateDecoration = const InputDecoration(
      labelText: AppConstants.expiryDate,
      hintText: AppConstants.expiryDateShort,
    ),
    this.cvvCodeDecoration = const InputDecoration(
      labelText: AppConstants.cvv,
      hintText: AppConstants.threeX,
    ),
    this.bankNameDecoration = const InputDecoration(
      labelText: AppConstants.defaultBankName,
      hintText: AppConstants.bankName,
    ),
    this.cardNumberTextStyle,
    this.cardHolderTextStyle,
    this.expiryDateTextStyle,
    this.cvvCodeTextStyle,
    this.bankNameTextStyle,
  });

  /// Provides decoration to card number text field.
  final InputDecoration cardNumberDecoration;

  /// Provides decoration to card holder text field.
  final InputDecoration cardHolderDecoration;

  /// Provides decoration to expiry date text field.
  final InputDecoration expiryDateDecoration;

  /// Provides decoration to cvv code text field.
  final InputDecoration cvvCodeDecoration;

  /// Provides decoration to bank name text field.
  final InputDecoration bankNameDecoration;

  /// Provides textStyle to card number text field.
  final TextStyle? cardNumberTextStyle;

  /// Provides textStyle to card holder text field.
  final TextStyle? cardHolderTextStyle;

  /// Provides textStyle to expiry date text field.
  final TextStyle? expiryDateTextStyle;

  /// Provides textStyle to cvv code text field.
  final TextStyle? cvvCodeTextStyle;

  /// Provides textStyle to bank name text field.
  final TextStyle? bankNameTextStyle;
}
