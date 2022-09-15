![alt text](https://github.com/simformsolutions/flutter_credit_card/blob/master/readme_assets/banner.png?raw=true)

# Flutter Credit Card

![build](https://github.com/SimformSolutionsPvtLtd/flutter_calendar_view/workflows/Build/badge.svg?branch=master)
![flutter_credit_card](https://img.shields.io/pub/v/flutter_credit_card?label=flutter_credit_card)

A Flutter package allows you to easily implement the Credit card's UI easily with the Card detection.

## Preview

![The example app running in Android](https://github.com/simformsolutions/flutter_credit_card/blob/master/readme_assets/preview.gif)

## Installing

1.  Add dependency to `pubspec.yaml`

    *Get the latest version in the 'Installing' tab on pub.dartlang.org*
    
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
      cardbgColor: Colors.black,
      glassmorphismConfig: Glassmorphism.defaultConfig(),
      backgroundImage: 'assets/card_bg.png',
      obscureCardNumber: true,
      obscureCardCvv: true,
      isHolderNameVisible: false,
      height: 175,
      textStyle: TextStyle(color: Colors.yellowAccent),
      width: MediaQuery.of(context).size.width,
      isChipVisible: true,
      isSwipeGestureEnabled: true,
      animationDuration: Duration(milliseconds: 1000),
      customCardIcons: <CustomCardTypeImage>[
        CustomCardTypeImage(
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

4.  Adding CreditCardForm

```dart
    CreditCardForm(
      formKey: formKey, // Required 
      cardNumberKey: cardNumberKey,
      cvvCodeKey: cvvCodeKey,
      expiryDateKey: expiryDateKey,
      cardHolderKey: cardHolderKey,
      onCreditCardModelChange: (CreditCardModel data) {}, // Required
      themeColor: Colors.red,
      obscureCvv: true, 
      obscureNumber: true,
      isHolderNameVisible: false,
      isCardNumberVisible: false,
      isExpiryDateVisible: false,
      cardNumberValidator: (String? cardNumber){},
      expiryDateValidator: (String? expiryDate){},
      cvvValidator: (String? cvv){},
      cardHolderValidator: (String? cardHolderName){},
      onFormComplete: () {
      // callback to execute at the end of filling card data
      },
      cardNumberDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Number',
        hintText: 'XXXX XXXX XXXX XXXX',
      ),
      expiryDateDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Expired Date',
        hintText: 'XX/XX',
      ),
      cvvCodeDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'CVV',
        hintText: 'XXX',
      ),
      cardHolderDecoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Card Holder',
      ),
    ),
```


## How to use
Check out the **example** app in the [example](example) directory or the 'Example' tab on pub.dartlang.org for a more complete example.

## Credit

This package's animation is inspired from from this [Dribbble](https://dribbble.com/shots/2187649-Credit-card-Checkout-flow-AMEX) art.

<br/>

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
