import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
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

  FocusNode _cvvFocus = FocusNode();

  CardFieldController numberController =
      CardFieldController(mask: '0000 0000 0000 0000');
  CardFieldController cvvController = CardFieldController(mask: '0000');
  CardFieldController nameController =
      CardFieldController(mask: 'AAAAAAAAAAAAAAAAAAAAAAAA');
  CardFieldController expiryController = CardFieldController(mask: '00/00');

  @override
  void initState() {
    _cvvFocus.addListener(() => setState(() {}));

    numberField = TextField(controller: numberController.controller);
    cvvField =
        TextField(controller: cvvController.controller, focusNode: _cvvFocus);
    expiryField = TextField(controller: expiryController.controller);
    nameField = TextField(controller: nameController.controller);
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
                cardNumber: numberController,
                expiryDate: expiryController,
                cardHolderName: nameController,
                cvvCode: cvvController,
                showBackView: _cvvFocus.hasFocus,
              ),
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
