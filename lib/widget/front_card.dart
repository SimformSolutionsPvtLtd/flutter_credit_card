import 'package:flutter/material.dart';
import 'package:flutter_credit_card/helper/helper.dart';
import 'package:flutter_credit_card/style/styles.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class FrontCard extends StatefulWidget {
  const FrontCard(
      {Key key,
      this.width,
      this.height,
      this.numberController,
      this.expiryController,
      this.nameController})
      : super(key: key);

  @override
  _FrontCardState createState() => _FrontCardState();
  final double width;
  final double height;

  final MaskedTextController numberController;
  final MaskedTextController expiryController;
  final MaskedTextController nameController;
}

class _FrontCardState extends State<FrontCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black26, offset: Offset(0, 0), blurRadius: 24)
        ],
        gradient: cardGradient(),
      ),
      width: widget.width ?? size(context).width,
      height: widget.height ??
          (orientation(context) == Orientation.portrait
              ? size(context).height / 4
              : size(context).height / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: getCardTypeIcon(widget.numberController.text),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.numberController.text.isEmpty
                    ? 'XXXX XXXX XXXX XXXX'
                    : widget.numberController.text,
                style: textCardStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.expiryController.text.isEmpty
                    ? 'MM/YY'
                    : widget.expiryController.text,
                style: textCardStyle,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                  widget.nameController.text.isEmpty
                      ? 'CARD HOLDER'
                      : widget.nameController.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textCardStyle),
            ),
          ),
        ],
      ),
    );
  }
}
