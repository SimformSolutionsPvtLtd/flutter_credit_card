import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/mask_text_controller.dart';
import 'package:flutter_credit_card/model/card_field.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

void main() => runApp(MySample());

class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySampleState();
  }
}

class MySampleState extends State<MySample> {
  bool isCvvFocused = false;

  TextField holderField;

  final _numberField = CardField(
      label: 'Card number',
      mask: 'XXXX XXXX XXXX XXXX',
      controller: MaskedTextController());
  final _nameField = CardField(
      label: 'Name field', mask: '', controller: MaskedTextController());
  final _expiryDate = CardField(
      label: 'Expiry date', mask: '', controller: MaskedTextController());
  final _cvvField =
      CardField(label: 'CVV', mask: '', controller: MaskedTextController());

  // final _fields = <CardField>[

  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    holderField = TextField(
        controller: _controllers[0],
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Card number'));
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
                cardNumber: _controllers[0],
                expiryDate: _controllers[1],
                cardHolderName: _controllers[2],
                cvvCode: _controllers[3],
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
