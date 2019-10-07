# Flutter Credit Card 2.0

A Flutter package allows you to easily implement the Credit card's UI easily with the Card detection. 



## Preview

![The example app running in Android](https://github.com/simformsolutions/flutter_credit_card/blob/master/preview/preview.gif)

## Installing

1.  Add dependency to `pubspec.yaml`

    *Get the latest version in the 'Installing' tab on pub.dartlang.org*
    
```dart
dependencies:
    flutter_credit_card: 0.1.1
```

2.  Import the package
```dart
import 'package:flutter_credit_card/flutter_credit_card.dart';
```

3.  Create your own InputFields
``` dart
TextField numberField;
TextField cvvField;
TextField expiryField;
TextField nameField;
```

4.  Create CardModel
``` dart
CardModel cardModel;
```

5.  Get controllers from model and pass to fields

```  dart
@override
  void initState() {
    cardModel = CardModel(frontCardColor: Colors.red);
    numberField = TextField(controller: cardModel.numberController);
    cvvField =
        TextField(controller: cardModel.cvvController, focusNode: cvvFocus);
    expiryField = TextField(controller: cardModel.expiryController);
    nameField = TextField(controller: cardModel.nameController);
    super.initState();
  }
  ```


  6. Customize  card
*Use CardModel class to cusotmize the entire card (OPTIONAL)) *
 •height,
 •width,
 •frontTextStyle,
 •backTextStyle,
 •animeDuration,
 • frontCardColor,
 • backCardColor,
 • numberMask = '0000 0000 0000 0000',
 • cvvMask = '0000',
 • nameMask = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
 • expiryMask = '00/00',
 
*This plugin uses https://binlist.io/ to retrieve the card info*

Forked from -> simformsolutions/flutter_credit_card