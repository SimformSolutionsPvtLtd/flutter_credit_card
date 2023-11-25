class CreditCardModel {
  CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName,
      this.cvvCode, this.isCvvFocused,this.bankName,this.type);

  /// Number of the credit/debit card.
  String cardNumber = '';

  /// Expiry date of the card.
  String expiryDate = '';

  /// Name of the card holder.
  String cardHolderName = '';

  /// Cvv code on card.
  String cvvCode = '';

  /// Bank name on card.
  String bankName = '';

  /// A boolean for indicating if cvv is focused or not.
  bool isCvvFocused = false;

  String type = '';
}
