# Overview

Flutter Credit Card is a Flutter package that allows you to easily implement credit card UI with
card detection functionality. The package provides elegant and customizable credit card widgets for
your Flutter applications.


## Preview

| ![The example app showing credit card widget](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_credit_card/master/readme_assets/preview.gif) | ![The example app showing card floating animation in mobile](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_credit_card/master/readme_assets/credit_card_float_preview.gif) | ![The example app showing card floating animation in web](https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_credit_card/master/readme_assets/credit_card_float_cursor_preview.gif) |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Glass morphism and Card Background                                                                                                                           | Floating Card on Mobile                                                                                                                                                                       | Floating Card on Web                                                                                                                                                                              |


## Key Features

- Realistic credit card UI with front and back views
- Card number, expiry date, cardholder name, and CVV input
- Card brand detection (Visa, Mastercard, etc.)
- Glassmorphism effect support
- Floating card animation
- Custom card background options
- Form validation
- Highly customizable appearance

# Installation

Follow these steps to add the Flutter Credit Card package to your project:

## 1. Add dependency to `pubspec.yaml`

Get the latest version from the 'Installing' tab on [pub.dev](https://pub.dev/packages/flutter_credit_card/install)

```yaml
dependencies:
  flutter_credit_card: <latest_version>
```

## 2. Run flutter packages get

```bash
flutter pub get
```

## 3. Import the package

```dart
import 'package:flutter_credit_card/flutter_credit_card.dart';
```

Now you're ready to use the Flutter Credit Card package in your project!

# Migration Guides

## Migration guide for Version 4.x.x

If you're updating from an earlier version to version 4.x.x, please note the following changes:

### Removed Properties

The following properties have been removed from `CreditCardForm` due to changes in how the package detects and applies application themes:
- `themeColor`
- `textColor`
- `cursorColor`

These properties are now managed through the Flutter application's theme. Please check the example app to learn how to apply these styles using the `Theme` widget.

### Relocated Properties

The following properties have been moved to the newly added `InputConfiguration` class:
- `cardNumberDecoration`
- `expiryDateDecoration`
- `cvvCodeDecoration`
- `cardHolderDecoration`

Additionally, the `InputConfiguration` class now includes `textStyle` properties for all the textFields of the `CreditCardForm`.

### Example Migration

Before (version 3.x.x):
```dart
CreditCardForm(
  formKey: formKey,
  cardNumber: cardNumber,
  expiryDate: expiryDate,
  cardHolderName: cardHolderName,
  cvvCode: cvvCode,
  onCreditCardModelChange: (CreditCardModel data) {},
  themeColor: Colors.blue,
  textColor: Colors.black,
  cursorColor: Colors.red,
  cardNumberDecoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Number',
    hintText: 'XXXX XXXX XXXX XXXX',
  ),
  expiryDateDecoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Expired Date',
    hintText: 'XX/XX',
  ),
  cvvCodeDecoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'CVV',
    hintText: 'XXX',
  ),
  cardHolderDecoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Card Holder',
  ),
),
```

After (version 4.x.x):
```dart
Theme(
  data: ThemeData(
    primaryColor: Colors.blue,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black),
    ),
  ),
  child: CreditCardForm(
    formKey: formKey,
    cardNumber: cardNumber,
    expiryDate: expiryDate,
    cardHolderName: cardHolderName,
    cvvCode: cvvCode,
    onCreditCardModelChange: (CreditCardModel data) {},
    inputConfiguration: InputConfiguration(
      cardNumberDecoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Number',
        hintText: 'XXXX XXXX XXXX XXXX',
      ),
      expiryDateDecoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Expired Date',
        hintText: 'XX/XX',
      ),
      cvvCodeDecoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'CVV',
        hintText: 'XXX',
      ),
      cardHolderDecoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Card Holder',
      ),
      // New text style properties
      cardNumberTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      cardHolderTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      expiryDateTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      cvvCodeTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
  ),
)
```

## Handling Theme and Cursor Color

In version 4.x.x, you should use Flutter's theming system to handle colors:

```dart
Theme(
  data: ThemeData(
    primaryColor: Colors.blue,        // Used for focus and active states
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.red,        // Cursor color
    ),
  ),
  child: CreditCardForm(
    // Your form configuration
  ),
)
```

For more details, please check the example app in the repository.

# Basic Usage

This guide covers the basic implementation of the Flutter Credit Card package in your Flutter application.

## CreditCardWidget

The `CreditCardWidget` is used to display a credit card with the provided information.

### Basic Implementation

```dart
CreditCardWidget(
  cardNumber: cardNumber,         // Required: Card number string
  expiryDate: expiryDate,         // Required: Expiry date string (MM/YY format)
  cardHolderName: cardHolderName, // Required: Cardholder name string
  cvvCode: cvvCode,               // Required: CVV code string
  showBackView: isCvvFocused,     // Required: Show back view when CVV is in focus
  onCreditCardWidgetChange: (CreditCardBrand brand) {
    // Callback triggered when credit card brand changes
  },
),
```

## CreditCardForm

The `CreditCardForm` is used to collect credit card information from the user.

### Basic Implementation

```dart
CreditCardForm(
  formKey: formKey,               // Required: Form key for validation
  cardNumber: cardNumber,         // Required: Card number string
  expiryDate: expiryDate,         // Required: Expiry date string
  cardHolderName: cardHolderName, // Required: Cardholder name string
  cvvCode: cvvCode,               // Required: CVV code string
  onCreditCardModelChange: (CreditCardModel data) {
    // Required: Callback to handle form changes
    setState(() {
      cardNumber = data.cardNumber;
      expiryDate = data.expiryDate;
      cardHolderName = data.cardHolderName;
      cvvCode = data.cvvCode;
      isCvvFocused = data.isCvvFocused;
    });
  },
),
```

## Complete Example

For a complete basic example, combine both widgets:

```dart
class CreditCardPage extends StatefulWidget {
  @override
  _CreditCardPageState createState() => _CreditCardPageState();
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
      appBar: AppBar(title: Text('Flutter Credit Card')),
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
          Expanded(
            child: SingleChildScrollView(
              child: CreditCardForm(
                formKey: formKey,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
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
            ),
          ),
        ],
      ),
    );
  }
}
```

# Advanced Usage

This guide covers advanced customization options for the Flutter Credit Card package.

## CreditCardWidget - Advanced Customization

### Custom Card Appearance

```dart
CreditCardWidget(
  // Required parameters
  cardNumber: cardNumber,
  expiryDate: expiryDate,
  cardHolderName: cardHolderName,
  cvvCode: cvvCode,
  showBackView: isCvvFocused,
  onCreditCardWidgetChange: (CreditCardBrand brand) {},
  
  // Optional parameters for customization
  bankName: 'Name of the Bank',
  cardBgColor: Colors.black87,
  height: 175,
  width: MediaQuery.of(context).size.width,
  textStyle: TextStyle(color: Colors.yellowAccent),
  padding: 16,
  isHolderNameVisible: false,
  obscureCardNumber: true,
  obscureInitialCardNumber: false,
  obscureCardCvv: true,
  isChipVisible: true,
  isSwipeGestureEnabled: true,
  animationDuration: Duration(milliseconds: 1000),
  frontCardBorder: Border.all(color: Colors.grey),
  backCardBorder: Border.all(color: Colors.grey),
  chipColor: Colors.red,
),
```

### Custom Card Background

```dart
CreditCardWidget(
  // Required parameters
  // ...
  
  // Background options
  cardBgColor: Colors.transparent, // When using background image
  backgroundImage: 'assets/card_bg.png',
  // OR
  backgroundNetworkImage: 'https://www.xyz.com/card_bg.png',
),
```

### Custom Labels

```dart
CreditCardWidget(
  // Required parameters
  // ...
  
  // Custom labels
  labelCardHolder: 'CARD OWNER',
  labelValidThru: 'VALID\nUNTIL',
),
```

### Custom Card Type Icons

```dart
CreditCardWidget(
  // Required parameters
  // ...
  
  customCardTypeIcons: <CustomCardTypeIcons>[
    CustomCardTypeIcons(
      cardType: CardType.mastercard,
      cardImage: Image.asset(
        'assets/mastercard.png',
        height: 48,
        width: 48,
      ),
    ),
    CustomCardTypeIcons(
      cardType: CardType.visa,
      cardImage: Image.asset(
        'assets/visa.png',
        height: 48,
        width: 48,
      ),
    ),
  ],
),
```

## Glassmorphism Effect

### Default Glassmorphism Configuration

```dart
CreditCardWidget(
  // Required parameters
  // ...
  
  glassmorphismConfig: Glassmorphism.defaultConfig(),
),
```

### Custom Glassmorphism Configuration

```dart
CreditCardWidget(
  // Required parameters
  // ...
  
  glassmorphismConfig: Glassmorphism(
    blurX: 10.0,
    blurY: 10.0,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Colors.grey.withAlpha(20),
        Colors.white.withAlpha(20),
      ],
      stops: const <double>[
        0.3,
        0,
      ],
    ),
  ),
),
```

## Floating Card Effect

### Default Floating Configuration

```dart
CreditCardWidget(
  // Required parameters
  // ...
  
  enableFloatingCard: true,
),
```

### Custom Floating Configuration

```dart
CreditCardWidget(
  // Required parameters
  // ...
  
  enableFloatingCard: true,
  floatingConfig: FloatingConfig(
    isGlareEnabled: true,
    isShadowEnabled: true,
    shadowConfig: FloatingShadowConfig(
      offset: Offset(10, 10),
      color: Colors.black.withOpacity(0.5),
      blurRadius: 15,
    ),
  ),
),
```

## CreditCardForm - Advanced Customization

### Custom Validation

```dart
CreditCardForm(
  // Required parameters
  // ...
  
  // Custom validators
  cardNumberValidator: (String? cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) {
      return 'Please enter card number';
    }
    // Add more validation logic
    return null; // Return null for valid input
  },
  expiryDateValidator: (String? expiryDate) {
    if (expiryDate == null || expiryDate.isEmpty) {
      return 'Please enter expiry date';
    }
    // Add more validation logic
    return null;
  },
  cvvValidator: (String? cvv) {
    if (cvv == null || cvv.isEmpty) {
      return 'Please enter CVV';
    }
    // Add more validation logic
    return null;
  },
  cardHolderValidator: (String? cardHolderName) {
    if (cardHolderName == null || cardHolderName.isEmpty) {
      return 'Please enter card holder name';
    }
    // Add more validation logic
    return null;
  },
),
```

### Custom Input Decoration

```dart
CreditCardForm(
  // Required parameters
  // ...
  
  inputConfiguration: const InputConfiguration(
    cardNumberDecoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Number',
      hintText: 'XXXX XXXX XXXX XXXX',
    ),
    expiryDateDecoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Expired Date',
      hintText: 'XX/XX',
    ),
    cvvCodeDecoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'CVV',
      hintText: 'XXX',
    ),
    cardHolderDecoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Card Holder',
    ),
    cardNumberTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    cardHolderTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    expiryDateTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    cvvCodeTextStyle: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
  ),
),
```

### Field Visibility Control

```dart
CreditCardForm(
  // Required parameters
  // ...
  
  // Control field visibility
  isHolderNameVisible: true,
  isCardNumberVisible: true,
  isExpiryDateVisible: true,
  enableCvv: true,
),
```

### Other Customizations

```dart
CreditCardForm(
  // Required parameters
  // ...
  
  // Additional configurations
  obscureCvv: true,
  obscureNumber: true,
  isCardHolderNameUpperCase: true,
  disableCardNumberAutoFillHints: false,
  autovalidateMode: AutovalidateMode.always,
  
  // Form completion callback
  onFormComplete: () {
    // Callback executed when all fields are valid
    print('Form is complete');
  },
),
```

> Note: Not all customizations need to be applied at once. Choose the ones that fit your requirements.


# Contributors

## Main Contributors

| ![img](https://avatars.githubusercontent.com/u/63042002?s=200) | ![img](https://avatars.githubusercontent.com/u/97207242?s=200) |    ![img](https://avatars.githubusercontent.com/u/56400956?s=200)     |   ![img](https://avatars.githubusercontent.com/u/41247722?s=200)   |
|:--------------------------------------------------------------:|:--------------------------------------------------------------:|:---------------------------------------------------------------------:|:----------------------------------------------------------------:|
|   [Shweta Chauhan](https://github.com/shwetachauhan-simform)   |        [Kavan Trivedi](https://github.com/kavantrivedi)        |          [Ujas Majithiya](https://github.com/Ujas-Majithiya)          |  [Aditya Chavda](https://github.com/aditya-chavda)           |


## How to Contribute

We welcome contributions from the community! Here's how you can help:

1. **Fork the repository**: Fork the [flutter_credit_card repository](https://github.com/simformsolutions/flutter_credit_card) on GitHub.

2. **Clone your fork**: Clone your fork to your local machine.

3. **Create a branch**: Create a new branch for your contribution.

4. **Make changes**: Make your changes or additions to the code.

5. **Test**: Make sure to test your changes thoroughly.

6. **Commit changes**: Commit your changes with a clear commit message.

7. **Push to your fork**: Push your changes to your fork.

8. **Create a pull request**: Create a pull request from your fork to the original repository.

## Code of Conduct

Please be respectful and considerate of others when contributing to this project.

## Credit

- This package's flip animation is inspired from this [Dribbble](https://dribbble.com/shots/2187649-Credit-card-Checkout-flow-AMEX) art.
- This package's float animation is inspired from the [Motion](https://pub.dev/packages/motion) flutter package.

## More Resources from Simform

- Check out our other available [awesome mobile libraries](https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries)

# License

```
MIT License

Copyright (c) 2021 Simform Solutions

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## License Change Notice

Please note that the license for Flutter Credit Card has been updated from BSD 2-Clause "Simplified" to MIT License on 28/09/2021.
