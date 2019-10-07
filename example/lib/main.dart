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

    cardModel = CardModel(frontCardColor: Colors.red);
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
