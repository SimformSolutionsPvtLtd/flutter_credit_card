abstract class CreditCardResult {
  CreditCardResult({
    this.expiryDate,
    this.cardNumber,
    this.holderName,
    this.cvv,
  });

  String? cardNumber;
  String? expiryDate;
  String? holderName;
  String? cvv;

  @override
  String toString() {
    return 'cardNumber: $cardNumber\nexpiryDate: '
        '$expiryDate\nholderName: $holderName\ncvv: $cvv';
  }
}

class CreditCardFrontResult extends CreditCardResult {
  CreditCardFrontResult({
    String? cardNumber,
    String? expiryDate,
    String? holderName,
  }) : super(
          holderName: holderName,
          expiryDate: expiryDate,
          cardNumber: cardNumber,
        );
}

class CreditCardBackResult extends CreditCardResult {
  CreditCardBackResult({String? cvv}) : super(cvv: cvv);
}
