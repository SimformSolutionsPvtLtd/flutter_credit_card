enum CardType {
  otherBrand,
  mastercard,
  visa,
  rupay,
  americanExpress,
  unionpay,
  discover,
  elo,
  hipercard,
}

/// The type of floating event.
enum FloatingType {
  pointer,
  gyroscope;

  bool get isPointer => this == pointer;

  bool get isGyroscope => this == gyroscope;
}
