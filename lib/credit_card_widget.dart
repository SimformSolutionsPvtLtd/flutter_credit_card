import 'package:flutter/material.dart';
import 'package:flutter_credit_card/style/styles.dart';
import 'package:flutter_credit_card/widget/animation_card.dart';
import 'package:flutter_credit_card/widget/back_card.dart';
import 'package:flutter_credit_card/widget/front_card.dart';

import 'model/card_model.dart';

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget({
    Key key,
    @required this.showBackView,
    @required this.cardModel,
  }) : super(key: key);

  final bool showBackView;
  final CardModel cardModel;

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  Gradient backgroundGradientColor;

  String numberString;
  bool isAmex = false;

  @override
  void dispose() {
    controller.dispose();
    widget.cardModel.controllers.forEach((f) => f.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.cardModel.controllers
        .forEach((f) => f.addListener(() => setState(() {})));

    controller = animationController(
      duration: widget.cardModel.animeDuration,
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
            textStyle: widget.cardModel.frontTextStyle,
            bgColor: widget.cardModel.frontCardColor,
            nameController: widget.cardModel.nameController,
            expiryController: widget.cardModel.expiryController,
            numberController: widget.cardModel.numberController,
          ),
        ),
        AnimationCard(
          animation: _backRotation,
          child: BackCard(
              textStyle: widget.cardModel.backTextStyle,
              bgColor: widget.cardModel.backCardColor,
              cvvController: widget.cardModel.cvvController,
              numberController: widget.cardModel.numberController),
        ),
      ],
    );
  }
}
