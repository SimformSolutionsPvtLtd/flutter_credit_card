import 'package:flutter/material.dart';
import 'package:flutter_credit_card/helper/helper.dart';
import 'package:flutter_credit_card/style/styles.dart';

class FrontCard extends StatefulWidget {
  const FrontCard({Key key, this.width, this.height}) : super(key: key);

  @override
  _FrontCardState createState() => _FrontCardState();
  final double width;
  final double height;
}

class _FrontCardState extends State<FrontCard> {
  @override
  Widget build(BuildContext context) {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.title.merge(textCardStyle);

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
              child: getCardTypeIcon(_numberController.text),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                _numberController.text.isEmpty || widget.cardNumber == null
                    ? 'XXXX XXXX XXXX XXXX'
                    : _numberController.text,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                _expiryController.text.isEmpty || widget.expiryDate == null
                    ? 'MM/YY'
                    : _expiryController.text,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                _nameController.text.isEmpty || widget.cardHolderName == null
                    ? 'CARD HOLDER'
                    : _nameController.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
