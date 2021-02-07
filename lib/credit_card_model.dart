class CreditCardModel {
  CreditCardModel(this.cardNumber, this.expiryDate, this.cardHolderName,
      this.cvvCode, this.postalCode, this.isCvvFocused);

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String postalCode = '';
  bool isCvvFocused = false;
}
