library flutter_credit_card;

import 'dart:math';

import 'package:flutter/material.dart';

class CreditCardWidget extends StatefulWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final TextStyle textStyle;
  final Color cardbgColor;
  final bool showBackView;
  final Duration animationDuration;
  final double height;
  final double width;

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
    this.cardbgColor = const Color(0xff1b447b),
  })  : assert(cardNumber != null),
        assert(showBackView != null),
        super(key: key);

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  Gradient backgroundGradientColor;

  bool isAmex = false;

  @override
  void initState() {
    super.initState();

    ///initialize the animation controller
    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    backgroundGradientColor = LinearGradient(
      // Where the linear gradient begins and ends
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: const [0.1, 0.4, 0.7, 0.9],
      colors: [
        widget.cardbgColor.withOpacity(1),
        widget.cardbgColor.withOpacity(0.97),
        widget.cardbgColor.withOpacity(0.90),
        widget.cardbgColor.withOpacity(0.86),
      ],
    );

    ///Initialize the Front to back rotation tween sequence.
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);

    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    ///
    /// If uer adds CVV then toggle the card from front to back..
    /// controller forward starts animation and shows back layout.
    /// controller reverse starts animation and shows front layout.
    ///
    if (widget.showBackView) {
      controller.forward();
    } else {
      controller.reverse();
    }

    return Stack(
      children: <Widget>[
        AnimationCard(
          animation: _frontRotation,
          child: buildFrontContainer(width, height, context, orientation),
        ),
        AnimationCard(
          animation: _backRotation,
          child: buildBackContainer(width, height, context, orientation),
        ),
      ],
    );
  }

  ///
  /// Builds a back container containing cvv
  ///
  Container buildBackContainer(
    double width,
    double height,
    BuildContext context,
    Orientation orientation,
  ) {
    var defaultTextStyle = Theme.of(context).textTheme.title.merge(
          TextStyle(
            color: Colors.black,
            fontFamily: "halter",
            fontSize: 16,
            package: "flutter_credit_card",
          ),
        );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 0), blurRadius: 24)
        ],
        gradient: backgroundGradientColor,
      ),
      margin: const EdgeInsets.all(16),
      width: widget.width ?? width,
      height: widget.height ??
          (orientation == Orientation.portrait ? height / 4 : height / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(top: 16),
              height: 48,
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(top: 16),
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
                          widget.cvvCode.isEmpty
                              ? isAmex ? "XXXX" : "XXX"
                              : widget.cvvCode,
                          maxLines: 1,
                          style: widget.textStyle ?? defaultTextStyle,
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
                child: getCardTypeIcon(widget.cardNumber),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Builds a front container containing
  /// Card number, Exp. year and Card holder name
  ///
  Container buildFrontContainer(
    double width,
    double height,
    BuildContext context,
    Orientation orientation,
  ) {
    var defaultTextStyle = Theme.of(context).textTheme.title.merge(
          TextStyle(
            color: Colors.white,
            fontFamily: "halter",
            fontSize: 16,
            package: "flutter_credit_card",
          ),
        );

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 0), blurRadius: 24)
        ],
        gradient: backgroundGradientColor,
      ),
      width: widget.width ?? width,
      height: widget.height ??
          (orientation == Orientation.portrait ? height / 4 : height / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: getCardTypeIcon(widget.cardNumber),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.cardNumber.isEmpty || widget.cardNumber == null
                    ? "XXXX XXXX XXXX XXXX"
                    : widget.cardNumber,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.expiryDate.isEmpty || widget.expiryDate == null
                    ? "MM/YY"
                    : widget.expiryDate,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                widget.cardHolderName.isEmpty || widget.cardHolderName == null
                    ? "CARD HOLDER"
                    : widget.cardHolderName,
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

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  Map<CardType, Set<List<String>>> cardNumPatterns = {
    CardType.visa: {
      ['4'],
    },
    CardType.americanExpress: {
      ['34'],
      ['37'],
    },
    CardType.discover: {
      ['6011'],
      ['622126', '622925'],
      ['644', '649'],
      ['65']
    },
    CardType.mastercard: {
      ['51', '55'],
      ['2221', '2229'],
      ['223', '229'],
      ['23', '26'],
      ['270', '271'],
      ['2720'],
    },
  };

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }

    cardNumPatterns.forEach(
      (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
              cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            int ccPrefixAsInt = int.parse(ccPatternStr);
            int startPatternPrefixAsInt = int.parse(patternRange[0]);
            int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  ///
  /// This method returns the icon for the visa card type if found
  /// else will return the empty container
  ///
  getCardTypeIcon(String cardNumber) {
    Widget icon;
    switch (detectCCType(cardNumber)) {
      case CardType.visa:
        icon = Image.asset(
          "icons/visa.png",
          height: 48,
          width: 48,
          package: "flutter_credit_card",
        );
        isAmex = false;
        break;

      case CardType.americanExpress:
        icon = Image.asset(
          "icons/amex.png",
          height: 48,
          width: 48,
          package: "flutter_credit_card",
        );
        isAmex = true;
        break;

      case CardType.mastercard:
        icon = Image.asset(
          "icons/mastercard.png",
          height: 48,
          width: 48,
          package: "flutter_credit_card",
        );
        isAmex = false;
        break;

      case CardType.discover:
        icon = Image.asset(
          "icons/discover.png",
          height: 48,
          width: 48,
          package: "flutter_credit_card",
        );
        isAmex = false;
        break;

      default:
        icon = Container(
          height: 48,
          width: 48,
        );
        isAmex = false;
        break;
    }

    return icon;
  }
}

class AnimationCard extends StatelessWidget {
  AnimationCard({
    @required this.child,
    @required this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        transform.rotateY(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

class MaskedTextController extends TextEditingController {
  MaskedTextController({String text, this.mask, Map<String, RegExp> translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    this.addListener(() {
      var previous = this._lastUpdatedText;
      if (this.beforeChange(previous, this.text)) {
        this.updateText(this.text);
        this.afterChange(previous, this.text);
      } else {
        this.updateText(this._lastUpdatedText);
      }
    });

    this.updateText(this.text);
  }

  String mask;

  Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text != null) {
      this.text = this._applyMask(this.mask, text);
    } else {
      this.text = '';
    }

    this._lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    this.updateText(this.text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    var text = this._lastUpdatedText;
    this.selection = new TextSelection.fromPosition(
        new TextPosition(offset: (text ?? '').length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      this.moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {
      'A': new RegExp(r'[A-Za-z]'),
      '0': new RegExp(r'[0-9]'),
      '@': new RegExp(r'[A-Za-z0-9]'),
      '*': new RegExp(r'.*')
    };
  }

  String _applyMask(String mask, String value) {
    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      var maskChar = mask[maskCharIndex];
      var valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (this.translator.containsKey(maskChar)) {
        if (this.translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}

enum CardType {
  otherBrand,
  mastercard,
  visa,
  americanExpress,
  discover,
}
