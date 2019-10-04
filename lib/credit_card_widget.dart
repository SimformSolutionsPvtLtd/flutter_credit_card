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
    this.cardBgColor = const Color(0xff1b447b),
  })  : assert(cardNumber != null),
        assert(showBackView != null),
        super(key: key);

  final CardFieldController cardNumber;
  final CardFieldController expiryDate;
  final CardFieldController cardHolderName;
  final CardFieldController cvvCode;
  final TextStyle textStyle;
  final Color cardBgColor;
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

  MaskedTextController _numberController;
  MaskedTextController _expiryController;
  MaskedTextController _nameController;
  MaskedTextController _cvvController;

  List<MaskedTextController> _controllers;

  bool isAmex = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _numberController = widget.cardNumber.controller;
    _expiryController = widget.expiryDate.controller;
    _nameController = widget.cardHolderName.controller;
    _cvvController = widget.cvvCode.controller;
    _controllers = <MaskedTextController>[
      _numberController,
      _expiryController,
      _nameController,
      _cvvController,
    ];
    _controllers.forEach((f) => f.addListener(() => setState(() {})));
    backgroundGradientColor = cardGradient();

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
            nameController: _nameController,
            expiryController: _expiryController,
            numberController: _numberController,
          ),
        ),
        AnimationCard(
          animation: _backRotation,
          child: BackCard(
              cvvController: _cvvController,
              numberController: _numberController),
        ),
      ],
    );
  }
}
