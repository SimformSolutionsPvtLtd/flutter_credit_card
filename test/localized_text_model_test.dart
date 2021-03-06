import 'package:flutter_credit_card/localized_text_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Object correctly instantiated with properties', () {
    const String cardNumberLabel = 'Kreditkartennummer';
    const String cardNumberHint = 'XXXX-XXXX-XXXX-XXXX';
    const String expiryDateLabel = 'Ablaufdatum';
    const String expiryDateHint = 'MM/JJ';
    const String cvvLabel = 'Kartenprüfnummer';
    const String cvvHint = 'XXX';
    const String cardHolderLabel = 'Karteninhaber';
    const String cardHolderHint = 'Max Mustermann';

    const LocalizedText localizedText = LocalizedText(
      cardNumberLabel: cardNumberLabel,
      cardNumberHint: cardNumberHint,
      expiryDateLabel: expiryDateLabel,
      expiryDateHint: expiryDateHint,
      cvvLabel: cvvLabel,
      cvvHint: cvvHint,
      cardHolderLabel: cardHolderLabel,
      cardHolderHint: cardHolderHint,
    );

    expect(localizedText.cardNumberLabel, cardNumberLabel);
    expect(localizedText.cardNumberHint, cardNumberHint);
    expect(localizedText.expiryDateLabel, expiryDateLabel);
    expect(localizedText.expiryDateHint, expiryDateHint);
    expect(localizedText.cvvLabel, cvvLabel);
    expect(localizedText.cvvHint, cvvHint);
    expect(localizedText.cardHolderLabel, cardHolderLabel);
    expect(localizedText.cardHolderHint, cardHolderHint);
  });

  test('Object correctly instantiated with defaults', () {
    const String cardNumberLabel = 'Card number';
    const String cardNumberHint = 'xxxx xxxx xxxx xxxx';
    const String expiryDateLabel = 'Expiry Date';
    const String expiryDateHint = 'MM/YY';
    const String cvvLabel = 'CVV';
    const String cvvHint = 'XXXX';
    const String cardHolderLabel = 'Card Holder';
    const String cardHolderHint = '';

    const LocalizedText localizedText = LocalizedText();

    expect(localizedText.cardNumberLabel, cardNumberLabel);
    expect(localizedText.cardNumberHint, cardNumberHint);
    expect(localizedText.expiryDateLabel, expiryDateLabel);
    expect(localizedText.expiryDateHint, expiryDateHint);
    expect(localizedText.cvvLabel, cvvLabel);
    expect(localizedText.cvvHint, cvvHint);
    expect(localizedText.cardHolderLabel, cardHolderLabel);
    expect(localizedText.cardHolderHint, cardHolderHint);
  });
}
