import 'package:flutter/material.dart';
import 'package:flutter_credit_card/model/card_field_controller.dart';

import 'package:flutter_credit_card/style/styles.dart';
import 'package:flutter_credit_card/widget/animation_card.dart';
import 'package:flutter_credit_card/widget/back_card.dart';
import 'package:flutter_credit_card/widget/front_card.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget({
    Key key,
    @required this.cardNumber,
    @required this.expiryDate,
    @required this.cardHolderName,
    @required this.cvvCode,
    @required this.showBackView,
    this.animationDuration = const Duration(milliseconds: 500),
    this.height,
    this.width,
    this.textStyle,
    this.frontCardColor,
    this.backCradColor,
  })  : assert(cardNumber != null),
        assert(showBackView != null),
        super(key: key);

  final CardFieldController cardNumber;
  final CardFieldController expiryDate;
  final CardFieldController cardHolderName;
  final CardFieldController cvvCode;
  final TextStyle textStyle;
  final Color frontCardColor;
  final Color backCradColor;
  final bool showBackView;
  final Duration animationDuration;
  final double height;
  final double width;

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  Gradient backgroundGradientColor;

  List<MaskedTextController> _controllers;

  String numberString;

  bool isAmex = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controllers = <MaskedTextController>[
      widget.cardNumber.controller,
      widget.expiryDate.controller,
      widget.cardHolderName.controller,
      widget.cvvCode.controller
    ];
    _controllers.forEach((f) => f.addListener(() => setState(() {})));

    // widget.cardNumber.controller.addListener(() => setState(() {
    //       numberString = widget.cardNumber.controller.text;
    //     }));

    controller = animationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _frontRotation = frontRotation(controller);
    _backRotation = backRotation(controller);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBackView) {
      controller.forward();
    } else {
      controller.reverse();
    }

    return Stack(
      children: <Widget>[
        AnimationCard(
          animation: _frontRotation,
          child: FrontCard(
            bgColor: widget.frontCardColor,
            nameController: widget.cardHolderName.controller,
            expiryController: widget.expiryDate.controller,
            numberController: widget.cardNumber.controller,
          ),
        ),
        AnimationCard(
          animation: _backRotation,
          child: BackCard(
              bgColor: widget.backCradColor,
              cvvController: widget.cvvCode.controller,
              numberController: widget.cvvCode.controller),
        ),
      ],
    );
  }
}
