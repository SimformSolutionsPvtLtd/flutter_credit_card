![banner](https://github.com/simformsolutions/flutter_credit_card/blob/master/readme_assets/banner.png?raw=true)

# Flutter Credit Card

![build](https://github.com/SimformSolutionsPvtLtd/flutter_credit_card/workflows/Build/badge.svg?branch=master)
[![flutter_credit_card](https://img.shields.io/pub/v/flutter_credit_card?label=flutter_credit_card)](https://pub.dev/packages/flutter_credit_card)

A Flutter package allows you to easily implement the Credit card's UI easily with the Card detection.

## Preview

<table>
    <tr>
        <td align="center">
            <figure>
                <figcaption><b>Glassmorphism and Card Background</b></figcaption>
                <hr/>
                <img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_credit_card/master/readme_assets/preview.gif" alt="The example app showing credit card widget" width="227"/>
            </figure>
        </td>
    </tr>
<tr><td></td></tr>
    <tr>
        <td align="center">
            <figure>
                <figcaption><b>Floating Card on Mobile</b></figcaption>
                <hr/>
                <img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_credit_card/master/readme_assets/credit_card_float_preview.gif" alt="The example app showing card floating animation in mobile" width="227"/>
            </figure>
        </td>
    </tr>
<tr><td></td></tr>
    <tr>
        <td align="center">
            <figure>
                <figcaption><b>Floating Card on Web</b></figcaption>
                <hr/>
                <img src="https://raw.githubusercontent.com/SimformSolutionsPvtLtd/flutter_credit_card/master/readme_assets/credit_card_float_cursor_preview.gif" alt="The example app showing card floating animation in web" width="227"/>
            </figure>
        </td>
    </tr>
</table>

## Migration guide for Version 4.x.x
- The `themeColor`, `textColor`, and `cursorColor` properties have been removed from `CreditCardForm` due to changes in how it detects and applies application themes. Please check out the example app to learn how to apply those using `Theme`.
- The `cardNumberDecoration`, `expiryDateDecoration`, `cvvCodeDecoration`, and `cardHolderDecoration` properties are moved to the newly added `InputDecoration` class that also has `textStyle` properties for all the textFields of the `CreditCardForm`.


## Installing

1.  Add dependency to `pubspec.yaml`

    Get the latest version from the 'Installing' tab on [pub.dev](https://pub.dev/packages/flutter_credit_card/install)
    
```dart
dependencies:
    flutter_credit_card: <latest_version>
```

2.  Import the package
```dart
import 'package:flutter_credit_card/flutter_credit_card.dart';
```

3.  Adding CreditCardWidget

*With required parameters*
```dart
    CreditCardWidget(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      showBackView: isCvvFocused, //true when you want to show cvv(back) view
      onCreditCardWidgetChange: (CreditCardBrand brand) {}, // Callback for anytime credit card brand is changed
    ),
```    

*With optional parameters*
```dart   
    CreditCardWidget(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      showBackView: isCvvFocused,
      onCreditCardWidgetChange: (CreditCardBrand brand) {},
      bankName: 'Name of the Bank',
      cardBgColor: Colors.black87,
      glassmorphismConfig: Glassmorphism.defaultConfig(),
      enableFloatingCard: true,
      floatingConfig: FloatingConfig(
        isGlareEnabled: true,
        isShadowEnabled: true,
        shadowConfig: FloatingShadowConfig(),
      ),
      backgroundImage: 'assets/card_bg.png',
      backgroundNetworkImage: 'https://www.xyz.com/card_bg.png',
      labelValidThru: 'VALID\nTHRU',
      obscureCardNumber: true,
      obscureInitialCardNumber: false,
      obscureCardCvv: true,
      labelCardHolder: 'CARD HOLDER',
      labelValidThru: 'VALID\nTHRU',
      cardType: CardType.mastercard,
      isHolderNameVisible: false,
      height: 175,
      textStyle: TextStyle(color: Colors.yellowAccent),
      width: MediaQuery.of(context).size.width,
      isChipVisible: true,
      isSwipeGestureEnabled: true,
      animationDuration: Duration(milliseconds: 1000),
      frontCardBorder: Border.all(color: Colors.grey),
      backCardBorder: Border.all(color: Colors.grey),
      chipColor: Colors.red,
      padding: 16,
      customCardTypeIcons: <CustomCardTypeIcons>[
        CustomCardTypeIcons(
          cardType: CardType.mastercard,
          cardImage: Image.asset(
            'assets/mastercard.png',
            height: 48,
            width: 48,
          ),
        ),
      ],
    ),
``` 

*Glassmorphism UI*

 + Default configuration
```dart
    CreditCardWidget(
      glassmorphismConfig: Glassmorphism.defaultConfig(),
    );
```    

 + Custom configuration
```dart
    CreditCardWidget(
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

*Floating Card*

+ Default Configuration
```dart
    CreditCardWidget(
        enableFloatingCard: true,
    );
```    

+ Custom Configuration
```dart
    CreditCardWidget(
        enableFloatingCard: true,
        floatingConfig: FloatingConfig(
            isGlareEnabled: true,
            isShadowEnabled: true,
            shadowConfig: FloatingShadowConfig(
              offset: Offset(10, 10),
              color: Colors.black84,
              blurRadius: 15,
            ),
        ),
    );
```    
> NOTE: Currently the floating card animation is not supported on mobile platform browsers.

4.  Adding CreditCardForm

```dart
    CreditCardForm(
      formKey: formKey, // Required 
      cardNumber: cardNumber, // Required
      expiryDate: expiryDate, // Required
      cardHolderName: cardHolderName, // Required
      cvvCode: cvvCode, // Required
      cardNumberKey: cardNumberKey,
      cvvCodeKey: cvvCodeKey,
      expiryDateKey: expiryDateKey,
      cardHolderKey: cardHolderKey,
      onCreditCardModelChange: (CreditCardModel data) {}, // Required
      obscureCvv: true, 
      obscureNumber: true,
      isHolderNameVisible: true,
      isCardNumberVisible: true,
      isExpiryDateVisible: true,
      enableCvv: true,
      cvvValidationMessage: 'Please input a valid CVV',
      dateValidationMessage: 'Please input a valid date',
      numberValidationMessage: 'Please input a valid number',
      cardNumberValidator: (String? cardNumber){},
      expiryDateValidator: (String? expiryDate){},
      cvvValidator: (String? cvv){},
      cardHolderValidator: (String? cardHolderName){},
      onFormComplete: () {
      // callback to execute at the end of filling card data
      },
      autovalidateMode: AutovalidateMode.always,
      disableCardNumberAutoFillHints: false,
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
          fontSize: 10,
          color: Colors.black,
        ),
        cardHolderTextStyle: TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
        expiryDateTextStyle: TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
        cvvCodeTextStyle: TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
      ),
    ),
```

## How to use
Check out the **example** app in the [example](example) directory or the 'Example' tab on pub.dartlang.org for a more complete example.

## Credit

- This package's flip animation is inspired from this [Dribbble](https://dribbble.com/shots/2187649-Credit-card-Checkout-flow-AMEX) art.
- This package's float animation is inspired from the [Motion](https://pub.dev/packages/motion) flutter package.

## Main Contributors

<table>
  <tr>
    <td align="center"><a href="https://github.com/vatsaltanna"><img src="https://avatars.githubusercontent.com/u/25323183?s=100" width="100px;" alt=""/><br /><sub><b>Vatsal Tanna</b></sub></a></td>
    <td align="center"><a href="https://github.com/DevarshRanpara"><img src="https://avatars.githubusercontent.com/u/26064415?s=100" width="100px;" alt=""/><br /><sub><b>Devarsh Ranpara</b></sub></a></td>
    <td align="center"><a href="https://github.com/Kashifalaliwala"><img src="https://avatars.githubusercontent.com/u/30998350?s=100" width="100px;" alt=""/><br /><sub><b>Kashifa Laliwala</b></sub></a></td>
    <td align="center"><a href="https://github.com/SanketKachhela"><img src="https://avatars.githubusercontent.com/u/20923896?s=100" width="100px;" alt=""/><br /><sub><b>Sanket Kachchela</b></sub></a></td>
    <td align="center"><a href="https://github.com/meetjanani"><img src="https://avatars.githubusercontent.com/u/32095359?s=100" width="100px;" alt=""/><br /><sub><b>Meet Janani</b></sub></a></td>
    <td align="center"><a href="https://github.com/shwetachauhan-simform"><img src="https://avatars.githubusercontent.com/u/63042002?s=100" width="100px;" alt=""/><br /><sub><b>Shweta Chauhan</b></sub></a></td>
    <td align="center"><a href="https://github.com/kavantrivedi"><img src="https://avatars.githubusercontent.com/u/97207242?s=100" width="100px;" alt=""/><br /><sub><b>Kavan Trivedi</b></sub></a></td>
    <td align="center"><a href="https://github.com/Ujas-Majithiya"><img src="https://avatars.githubusercontent.com/u/56400956?v=4" width="100px;" alt=""/><br /><sub><b>Ujas Majithiya</b></sub></a></td>
    <td align="center"><a href="https://github.com/aditya-chavda"><img src="https://avatars.githubusercontent.com/u/41247722?v=4" width="100px;" alt=""/><br /><sub><b>Aditya Chavda</b></sub></a></td>
  </tr>
</table>
<br/>

## Awesome Mobile Libraries
- Check out our other available [awesome mobile libraries](https://github.com/SimformSolutionsPvtLtd/Awesome-Mobile-Libraries)

## Note
We have updated license of flutter_credit_card from BSD 2-Clause "Simplified" to MIT.

## License

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
