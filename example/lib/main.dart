import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CreditCardForm(
          onCardNumber: onCardNumber,
          onCardHolderName: onCardHolderName,
          onExpireDate: onExpireDate,
          onCVV: onCVV),
    );
  }

  void onCardNumber(String cardNumber) {
    print(cardNumber);
  }

  void onExpireDate(String expireDate) {
    print(expireDate);
  }

  void onCardHolderName(String cardHolderName) {
    print(cardHolderName);
  }

  void onCVV(String cvv) {
    print(cvv);
  }
}
