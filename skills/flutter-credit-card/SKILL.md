---
name: flutter-credit-card
description: >
  Use when adding a credit card UI widget or form to a Flutter app.
  Covers CreditCardWidget, CreditCardForm, state sync, card type detection,
  glassmorphism, flip/float animations, and custom card type icons.
---

# flutter_credit_card

## When to use this skill

Load this skill whenever you need to:
- Display a credit card widget (front/back flip, float animation)
- Build a credit card entry form with validation
- Detect card brand automatically from the card number
- Apply glassmorphism, custom backgrounds, or custom card type icons

---

## 1. Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter_credit_card: ^4.1.0
```

Import:

```dart
import 'package:flutter_credit_card/flutter_credit_card.dart';
```

---

## 2. Minimal working example

Both widgets share state via `CreditCardModel`. Manage it in a `StatefulWidget`:

```dart
class CreditCardPage extends StatefulWidget {
  const CreditCardPage({super.key});

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            onCreditCardWidgetChange: (CreditCardBrand brand) {},
          ),
          CreditCardForm(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            formKey: formKey,
            onCreditCardModelChange: (CreditCardModel data) {
              setState(() {
                cardNumber = data.cardNumber;
                expiryDate = data.expiryDate;
                cardHolderName = data.cardHolderName;
                cvvCode = data.cvvCode;
                isCvvFocused = data.isCvvFocused;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // submit
              }
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }
}
```

**Key rule:** `CreditCardWidget.showBackView` must equal `CreditCardModel.isCvvFocused` so the widget flips when the CVV field is focused.

---

## 3. CreditCardWidget parameters

See [references/widget-api.md](references/widget-api.md) for the full parameter table.

Commonly used:

| Parameter | Type | Default | Purpose |
|---|---|---|---|
| `cardNumber` | `String` | required | Card number string (may contain spaces) |
| `expiryDate` | `String` | required | `MM/YY` format |
| `cardHolderName` | `String` | required | Displayed on front face |
| `cvvCode` | `String` | required | 3–4 digit CVV |
| `showBackView` | `bool` | required | `true` flips to CVV face |
| `onCreditCardWidgetChange` | `Function(CreditCardBrand)` | required | Called on card brand change |
| `bankName` | `String?` | `null` | Shown on front if set |
| `cardBgColor` | `Color` | `#222D65` | Background color when no image |
| `backgroundImage` | `String?` | `null` | Asset image path for card bg |
| `backgroundNetworkImage` | `String?` | `null` | Network image for card bg |
| `glassmorphismConfig` | `Glassmorphism?` | `null` | Glassmorphism effect |
| `enableFloatingCard` | `bool` | `false` | Gyroscope/pointer float |
| `floatingConfig` | `FloatingConfig` | default | Float behavior |
| `obscureCardNumber` | `bool` | `true` | Mask middle digits |
| `obscureCardCvv` | `bool` | `true` | Mask CVV on back |
| `isChipVisible` | `bool` | `true` | Show chip on front |
| `isHolderNameVisible` | `bool` | `false` | Show holder name |
| `customCardTypeIcons` | `List<CustomCardTypeIcon>` | `[]` | Override brand icons |
| `animationDuration` | `Duration` | 500ms | Flip animation speed |

---

## 4. CreditCardForm parameters

| Parameter | Type | Required | Purpose |
|---|---|---|---|
| `cardNumber` | `String` | yes | Controlled value |
| `expiryDate` | `String` | yes | Controlled value |
| `cardHolderName` | `String` | yes | Controlled value |
| `cvvCode` | `String` | yes | Controlled value |
| `onCreditCardModelChange` | `Function(CreditCardModel)` | yes | State sync callback |
| `formKey` | `GlobalKey<FormState>` | yes | For `validate()` |
| `inputConfiguration` | `InputConfiguration` | no | Styling all fields |
| `isHolderNameVisible` | `bool` | no | Show holder field (default true) |
| `isCardNumberVisible` | `bool` | no | Show number field (default true) |
| `isExpiryDateVisible` | `bool` | no | Show expiry field (default true) |
| `enableCvv` | `bool` | no | Show CVV field (default true) |
| `cardNumberValidator` | `String? Function(String?)?` | no | Custom card number validation |
| `expiryDateValidator` | `String? Function(String?)?` | no | Custom expiry validation |
| `cvvValidator` | `String? Function(String?)?` | no | Custom CVV validation |
| `cardHolderValidator` | `String? Function(String?)?` | no | Custom holder name validation |
| `autovalidateMode` | `AutovalidateMode?` | no | Flutter form auto-validate |
| `isCardHolderNameUpperCase` | `bool` | no | Force uppercase holder input |

---

## 5. Styling the form with InputConfiguration

Use `InputConfiguration` to style all four text fields consistently:

```dart
CreditCardForm(
  // ...
  inputConfiguration: const InputConfiguration(
    cardNumberDecoration: InputDecoration(
      labelText: 'Card Number',
      hintText: 'XXXX XXXX XXXX XXXX',
      border: OutlineInputBorder(),
    ),
    expiryDateDecoration: InputDecoration(
      labelText: 'Expiry Date',
      hintText: 'MM/YY',
      border: OutlineInputBorder(),
    ),
    cvvCodeDecoration: InputDecoration(
      labelText: 'CVV',
      hintText: 'XXX',
      border: OutlineInputBorder(),
    ),
    cardHolderDecoration: InputDecoration(
      labelText: 'Card Holder',
      border: OutlineInputBorder(),
    ),
    cardNumberTextStyle: TextStyle(fontSize: 14),
    expiryDateTextStyle: TextStyle(fontSize: 14),
    cvvCodeTextStyle: TextStyle(fontSize: 14),
    cardHolderTextStyle: TextStyle(fontSize: 14),
  ),
),
```

Theme-based styling: wrap with `Theme(data: Theme.of(context).copyWith(inputDecorationTheme: ...))`.

---

## 6. Glassmorphism

```dart
CreditCardWidget(
  // ...
  glassmorphismConfig: Glassmorphism(
    blurX: 8.0,
    blurY: 8.0,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.25),
        Colors.white.withOpacity(0.1),
      ],
    ),
  ),
),
```

Use `Glassmorphism.defaultConfig()` for the built-in preset.

---

## 7. Floating card animation

Enable the float effect (gyroscope on mobile, pointer on web):

```dart
CreditCardWidget(
  // ...
  enableFloatingCard: true,
  floatingConfig: const FloatingConfig(
    // defaults work for most use cases
  ),
),
```

`FloatingType.gyroscope` — reacts to device tilt. Requires gyroscope hardware.  
`FloatingType.pointer` — reacts to mouse cursor position (web/desktop).  
The widget auto-selects the right type, but you can override via `FloatingConfig`.

---

## 8. Custom card type icons

Override the icon for one or more card brands:

```dart
CreditCardWidget(
  // ...
  customCardTypeIcons: [
    CustomCardTypeIcon(
      cardType: CardType.visa,
      cardImage: Image.asset('assets/visa_custom.png', height: 48),
    ),
  ],
),
```

Supported `CardType` values: `visa`, `mastercard`, `americanExpress`, `discover`, `unionpay`, `rupay`, `elo`, `hipercard`, `mir`, `otherBrand`.

---

## 9. Card type detection

Card type is detected automatically from the number. Listen via the `onCreditCardWidgetChange` callback:

```dart
onCreditCardWidgetChange: (CreditCardBrand brand) {
  // brand.brandName is a CardType enum value
  print(brand.brandName); // e.g. CardType.visa
},
```

---

## 10. Version 4.x migration guide

If upgrading from 3.x:

- Remove `themeColor`, `textColor`, `cursorColor` from `CreditCardForm` — use `Theme` instead.
- Replace the old per-field decoration parameters (`cardNumberDecoration`, etc.) with the new `InputConfiguration` class.