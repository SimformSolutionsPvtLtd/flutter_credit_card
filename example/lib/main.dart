import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/model/card_field.dart';

void main() => runApp(MySample());

class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MySampleState();
}

class MySampleState extends State<MySample> {
  bool isCvvFocused = false;

  TextField holderField;
  CardFieldController numberField =
      CardFieldController(mask: '0000 0000 0000 0000 ');

  @override
  void initState() {
    holderField = TextField(controller: numberField.controller);
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
                cardNumber: numberField,
                expiryDate: numberField,
                cardHolderName: numberField,
                cvvCode: numberField,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: holderField,
              )
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: CreditCardForm(
              //       onCreditCardModelChange: onCreditCardModelChange,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  // void onCreditCardModelChange(CreditCardModel creditCardModel) {
  //   setState(() {
  //     cardNumber = creditCardModel.cardNumber;
  //     expiryDate = creditCardModel.expiryDate;
  //     cardHolderName = creditCardModel.cardHolderName;
  //     cvvCode = creditCardModel.cvvCode;
  //     isCvvFocused = creditCardModel.isCvvFocused;
  //   });
  // }
}
