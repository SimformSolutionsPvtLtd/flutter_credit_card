
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

2.  Adding CreditCardForm

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