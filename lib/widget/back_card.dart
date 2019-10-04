import 'package:flutter/material.dart';
import 'package:flutter_credit_card/helper/helper.dart';
import 'package:flutter_credit_card/style/styles.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class BackCard extends StatefulWidget {
  const BackCard(
      {Key key,
      this.width,
      this.height,
      @required this.cvvController,
      @required this.numberController,
      this.bgColor})
      : super(key: key);

  @override
  _BackCardState createState() => _BackCardState();
  final double width;
  final double height;
  final Color bgColor;

  final MaskedTextController cvvController;
  final MaskedTextController numberController;
}

class _BackCardState extends State<BackCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 0),
            blurRadius: 24,
          ),
        ],
        gradient: cardGradient(color: widget.bgColor),
      ),
      margin: const EdgeInsets.all(16),
      width: widget.width ?? size(context).width,
      height: widget.height ??
          (orientation(context) == Orientation.portrait
              ? size(context).height / 4
              : size(context).height / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              height: 48,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Container(
                      height: 48,
                      color: Colors.white70,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          widget.cvvController.text.isEmpty
                              ? 'XXX'
                              : widget.cvvController.text,
                          maxLines: 1,
                          style: textCardStyle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child:
                    Container(), //getCardTypeIcon(widget.numberController.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
