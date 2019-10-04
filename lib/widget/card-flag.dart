import 'package:flutter/material.dart';
import 'package:flutter_credit_card/helper/helper.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CardFlag extends StatefulWidget {
  const CardFlag({Key key, this.numberController}) : super(key: key);

  @override
  _CardFlagState createState() => _CardFlagState();
  final MaskedTextController numberController;
}

class _CardFlagState extends State<CardFlag> {
  @override
  void initState() {
    super.initState();
    widget.numberController
        .addListener(() => getCardBin(widget.numberController.text));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getCardBin(widget.numberController.text),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.data != null) {
          return snapshot.data;
        } else {
          return Container();
        }
      },
    );
  }
}
