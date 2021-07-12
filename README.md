# Flutter Credit Card

A Flutter package allows you to easily implement the Credit card's UI easily with the Card detection.

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e546818ff64e4883a18a920f6a1c091c)](https://www.codacy.com/app/reg_3/flutter_credit_card?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=simformsolutions/flutter_credit_card&amp;utm_campaign=Badge_Grade)

## Preview

![The example app running in Android](https://github.com/simformsolutions/flutter_credit_card/blob/master/preview/preview.gif)

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
        obscureCardNumber: true,
        obscureCardCvv: true,
        isHolderNameVisible: false,
        height: 175,
        textStyle: TextStyle(color: Colors.yellowAccent),
        width: MediaQuery.of(context).size.width,
        animationDuration: Duration(milliseconds: 1000),
    ),
``` 
3.  Adding CreditCardForm

```dart
    CreditCardForm(
      formKey: formKey, // Required 
      onCreditCardModelChange: (CreditCardModel data) {}, // Required
      themeColor: Colors.red,
      obscureCvv: true, 
      obscureNumber: true,
      isHolderNameVisible: false,
      isCardNumberVisible: false,
      isExpiryDateVisible: false,
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


## License

```
BSD 2-Clause License

Copyright (c) 2019, Simform Solutions
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```