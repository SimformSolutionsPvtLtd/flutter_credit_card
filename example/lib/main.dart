import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";

  MaskedTextController _cardNumberController =
      MaskedTextController(mask: "0000 0000 0000 0000");
  TextEditingController _expiryDateController =
      MaskedTextController(mask: "00/00");
  TextEditingController _cardHolderNameController = TextEditingController();
  TextEditingController _cvvCodeController = TextEditingController();

  FocusNode cvvFocusNode = FocusNode();

  bool isCvvFocused = false;

  void textFieldFocusDidChange() {
    setState(() {
      isCvvFocused = cvvFocusNode.hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();

    cvvFocusNode.addListener(textFieldFocusDidChange);

    _cardNumberController.addListener(() {
      setState(() {
        cardNumber = _cardNumberController.text;
      });
    });

    _expiryDateController.addListener(() {
      setState(() {
        expiryDate = _expiryDateController.text;
      });
    });

    _cardHolderNameController.addListener(() {
      setState(() {
        cardHolderName = _cardHolderNameController.text;
      });
    });

    _cvvCodeController.addListener(() {
      setState(() {
        cvvCode = _cvvCodeController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: TextFormField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Card number",
                            hintText: "xxxx xxxx xxxx xxxx",
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 201,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: TextFormField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Expired Date",
                              hintText: "MM/YY"),
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: TextFormField(
                          controller: _cardHolderNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Card Holder",
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: TextField(
                          focusNode: cvvFocusNode,
                          controller: _cvvCodeController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "CVV",
                              hintText: "XXX"),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          maxLength: 3,
                          onChanged: (text) {
                            setState(() {
                              cvvCode = text;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
