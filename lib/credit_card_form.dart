import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'credit_card_model.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key key,
    this.cardNumber,
    this.expiryDate,
    this.cardHolderName,
    this.cvvCode,
    @required this.onCreditCardModelChange,
    this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
  Color themeColor;

  void Function(CreditCardModel) onCreditCardModelChange;
  CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();
  FocusNode cardNumberNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber ?? '';
    expiryDate = widget.expiryDate ?? '';
    cardHolderName = widget.cardHolderName ?? '';
    cvvCode = widget.cvvCode ?? '';

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    onCreditCardModelChange = widget.onCreditCardModelChange;

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
        creditCardModel.cardNumber = cardNumber;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
        creditCardModel.expiryDate = expiryDate;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
        creditCardModel.cardHolderName = cardHolderName;
        onCreditCardModelChange(creditCardModel);
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
        creditCardModel.cvvCode = cvvCode;
        onCreditCardModelChange(creditCardModel);
      });
    });
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    child: const Text('Card Holder Name'),
                  ),
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAEAEA),
                    ),
                    child: TextFormField(
                      controller: _cardHolderNameController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      style: TextStyle(
                        color: widget.textColor,
                      ),
                      focusNode: cardHolderNode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),

                        // labelText: 'Card Holder',
                        hintText: 'Name',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(cardNumberNode);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    child: const Text('Card Number'),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAEAEA),
                    ),
                    margin: const EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: _cardNumberController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      style: TextStyle(
                        color: widget.textColor,
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(expiryDateNode);
                      },
                      focusNode: cardNumberNode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        // labelText: 'Card number',
                        hintText: 'xxxx xxxx xxxx xxxx',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Expiry Date',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAEAEA),
                        ),
                        margin: const EdgeInsets.all(4.0),
                        width: 150,
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          controller: _expiryDateController,
                          cursorColor: widget.cursorColor ?? themeColor,
                          style: TextStyle(
                            color: widget.textColor,
                          ),
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(cvvFocusNode);
                          },
                          focusNode: expiryDateNode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            // labelText: 'Expiry Date',
                            hintText: 'MM/YY',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          child: const Text('CVV Code'),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.centerRight,
                          width: 150,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAEAEA),
                          ),
                          child: TextField(
                            focusNode: cvvFocusNode,
                            controller: _cvvCodeController,
                            cursorColor: widget.cursorColor ?? themeColor,
                            style: TextStyle(
                              color: widget.textColor,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '3 - 4 Digits',
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            onChanged: (String text) {
                              setState(() {
                                cvvCode = text;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
