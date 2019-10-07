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
    cardModel = CardModel(); // PASS CUSTOM PARAMS HERE
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



7. Complete Example

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

void main() => runApp(MySample());

class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MySampleState();
}

class MySampleState extends State<MySample> {
  bool isCvvFocused = false;

  TextField numberField;
  TextField cvvField;
  TextField expiryField;
  TextField nameField;

  CardModel cardModel;
  FocusNode cvvFocus = FocusNode();

  @override
  void initState() {
    cvvFocus.addListener(() => setState(() {}));

    cardModel = CardModel(
      frontCardColor: Colors.red, // OPTIONAL
      backCardColor: Colors.black,// OPTIONAL
      backTextStyle: TextStyle(color: Colors.white),// OPTIONAL
      frontTextStyle: TextStyle(color: Colors.white),// OPTIONAL
      animeDuration: Duration(seconds: 1),// OPTIONAL
      cvvMask: '000',// OPTIONAL
      expiryMask: '0000',// OPTIONAL
      ...// OPTIONAL
    );

    numberField = TextField(controller: cardModel.numberController);
    cvvField =
        TextField(controller: cardModel.cvvController, focusNode: cvvFocus);
    expiryField = TextField(controller: cardModel.expiryController);
    nameField = TextField(controller: cardModel.nameController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardModel: cardModel,
                showBackView: cvvFocus.hasFocus,
              ),
              //USE YOUR OWN TEXTFIELDS
              Expanded(child: numberField),
              Expanded(child: nameField),
              Expanded(child: expiryField),
              Expanded(child: cvvField),
            ],
          ),
        ),
      ),
    );
  }
}
```