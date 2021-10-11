import 'dart:math';

import 'package:flutter/material.dart';

import 'credit_card_animation.dart';
import 'credit_card_background.dart';
import 'credit_card_brand.dart';
import 'custom_card_type_icon.dart';
import 'glassmorphism_config.dart';

const Map<CardType, String> CardTypeIconAsset = <CardType, String>{
  CardType.visa: 'icons/visa.png',
  CardType.americanExpress: 'icons/amex.png',
  CardType.mastercard: 'icons/mastercard.png',
  CardType.discover: 'icons/discover.png',
};

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget(
      {Key? key,
      required this.cardNumber,
      required this.expiryDate,
      required this.cardHolderName,
      required this.cvvCode,
      required this.showBackView,
      this.animationDuration = const Duration(milliseconds: 500),
      this.height,
      this.width,
      this.textStyle,
      this.cardBgColor = const Color(0xff1b447b),
      this.obscureCardNumber = true,
      this.obscureCardCvv = true,
      this.labelCardHolder = 'CARD HOLDER',
      this.labelExpiredDate = 'MM/YY',
      this.cardType,
      this.isHolderNameVisible = false,
      this.backgroundImage,
      this.glassmorphismConfig,
      this.isChipVisible = true,
      this.isSwipeGestureEnabled = true,
      this.customCardTypeIcons = const <CustomCardTypeIcon>[],
      required this.onCreditCardWidgetChange})
      : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final TextStyle? textStyle;
  final Color cardBgColor;
  final bool showBackView;
  final Duration animationDuration;
  final double? height;
  final double? width;
  final bool obscureCardNumber;
  final bool obscureCardCvv;
  final void Function(CreditCardBrand) onCreditCardWidgetChange;
  final bool isHolderNameVisible;
  final String? backgroundImage;
  final bool isChipVisible;
  final Glassmorphism? glassmorphismConfig;
  final bool isSwipeGestureEnabled;

  final String labelCardHolder;
  final String labelExpiredDate;

  final CardType? cardType;
  final List<CustomCardTypeIcon> customCardTypeIcons;

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  late Gradient backgroundGradientColor;
  late bool isFrontVisible = true;
  late bool isGestureUpdate = false;

  bool isAmex = false;

  @override
  void initState() {
    super.initState();

    ///initialize the animation controller
    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _gradientSetup();
    _updateRotations(false);
  }

  void _gradientSetup() {
    backgroundGradientColor = LinearGradient(
      // Where the linear gradient begins and ends
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: const <double>[0.1, 0.4, 0.7, 0.9],
      colors: <Color>[
        widget.cardBgColor.withOpacity(1),
        widget.cardBgColor.withOpacity(0.97),
        widget.cardBgColor.withOpacity(0.90),
        widget.cardBgColor.withOpacity(0.86),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// If uer adds CVV then toggle the card from front to back..
    /// controller forward starts animation and shows back layout.
    /// controller reverse starts animation and shows front layout.
    ///
    if (!isGestureUpdate) {
      _updateRotations(false);
      if (widget.showBackView) {
        controller.forward();
      } else {
        controller.reverse();
      }
    } else {
      isGestureUpdate = false;
    }

    final CardType? cardType = widget.cardType != null
        ? widget.cardType
        : detectCCType(widget.cardNumber);
    widget.onCreditCardWidgetChange(CreditCardBrand(cardType));

    return Stack(
      children: <Widget>[
        _cardGesture(
          child: AnimationCard(
            animation: _frontRotation,
            child: _buildFrontContainer(),
          ),
        ),
        _cardGesture(
          child: AnimationCard(
            animation: _backRotation,
            child: _buildBackContainer(),
          ),
        ),
      ],
    );
  }

  void _leftRotation() {
    _toggleSide(false);
  }

  void _rightRotation() {
    _toggleSide(true);
  }

  void _toggleSide(bool isRightTap) {
    _updateRotations(!isRightTap);
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
  }

  void _updateRotations(bool isRightSwipe) {
    setState(() {
      final bool rotateToLeft =
          (isFrontVisible && !isRightSwipe) || !isFrontVisible && isRightSwipe;

      ///Initialize the Front to back rotation tween sequence.
      _frontRotation = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(
                    begin: 0.0, end: rotateToLeft ? (pi / 2) : (-pi / 2))
                .chain(CurveTween(curve: Curves.linear)),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(rotateToLeft ? (-pi / 2) : (pi / 2)),
            weight: 50.0,
          ),
        ],
      ).animate(controller);

      ///Initialize the Back to Front rotation tween sequence.
      _backRotation = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(rotateToLeft ? (pi / 2) : (-pi / 2)),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(
                    begin: rotateToLeft ? (-pi / 2) : (pi / 2), end: 0.0)
                .chain(
              CurveTween(curve: Curves.linear),
            ),
            weight: 50.0,
          ),
        ],
      ).animate(controller);
    });
  }

  ///
  /// Builds a front container containing
  /// Card number, Exp. year and Card holder name
  ///
  Widget _buildFrontContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.white,
                fontFamily: 'halter',
                fontSize: 16,
                package: 'flutter_credit_card',
              ),
            );

    final String number = widget.obscureCardNumber
        ? widget.cardNumber.replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*')
        : widget.cardNumber;
    return CardBackground(
      backgroundImage: widget.backgroundImage,
      backgroundGradientColor: backgroundGradientColor,
      glassmorphismConfig: widget.glassmorphismConfig,
      height: widget.height,
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: widget.isChipVisible ? 2 : 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (widget.isChipVisible)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Image.asset(
                      'icons/chip.png',
                      package: 'flutter_credit_card',
                      scale: 1,
                    ),
                  ),
                const Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: widget.cardType != null
                        ? getCardTypeImage(widget.cardType)
                        : getCardTypeIcon(widget.cardNumber),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.cardNumber.isEmpty ? 'XXXX XXXX XXXX XXXX' : number,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'VALID\nTHRU',
                    style: widget.textStyle ??
                        defaultTextStyle.copyWith(fontSize: 7),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.expiryDate.isEmpty
                        ? widget.labelExpiredDate
                        : widget.expiryDate,
                    style: widget.textStyle ?? defaultTextStyle,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.isHolderNameVisible,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Text(
                  widget.cardHolderName.isEmpty
                      ? widget.labelCardHolder
                      : widget.cardHolderName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: widget.textStyle ?? defaultTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Builds a back container containing cvv
  ///
  Widget _buildBackContainer() {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.headline6!.merge(
              const TextStyle(
                color: Colors.black,
                fontFamily: 'halter',
                fontSize: 16,
                package: 'flutter_credit_card',
              ),
            );

    final String cvv = widget.obscureCardCvv
        ? widget.cvvCode.replaceAll(RegExp(r'\d'), '*')
        : widget.cvvCode;

    return CardBackground(
      backgroundImage: widget.backgroundImage,
      backgroundGradientColor: backgroundGradientColor,
      glassmorphismConfig: widget.glassmorphismConfig,
      height: widget.height,
      width: widget.width,
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
                          widget.cvvCode.isEmpty
                              ? isAmex
                                  ? 'XXXX'
                                  : 'XXX'
                              : cvv,
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
                child: widget.cardType != null
                    ? getCardTypeImage(widget.cardType)
                    : getCardTypeIcon(widget.cardNumber),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardGesture({required Widget child}) {
    bool isRightSwipe = true;
    return widget.isSwipeGestureEnabled
        ? GestureDetector(
            onPanEnd: (_) {
              isGestureUpdate = true;
              if (isRightSwipe) {
                _leftRotation();
              } else {
                _rightRotation();
              }
            },
            onPanUpdate: (DragUpdateDetails details) {
              // Swiping in right direction.
              if (details.delta.dx > 0) {
                isRightSwipe = true;
              }

              // Swiping in left direction.
              if (details.delta.dx < 0) {
                isRightSwipe = false;
              }
            },
            child: child,
          )
        : child;
  }

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  Map<CardType, Set<List<String>>> cardNumPatterns =
      <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
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
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
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

  Widget getCardTypeImage(CardType? cardType) {
    final List<CustomCardTypeIcon> customCardTypeIcon = getCustomCardTypeIcon(cardType!);
    if(customCardTypeIcon.isNotEmpty){
      return customCardTypeIcon.first.cardImage;
    } else {
      return Image.asset(
        CardTypeIconAsset[cardType]!,
        height: 48,
        width: 48,
        package: 'flutter_credit_card',
      );
    }
  }

    // This method returns the icon for the visa card type if found
    // else will return the empty container
  Widget getCardTypeIcon(String cardNumber) {
    Widget icon;
    final CardType ccType = detectCCType(cardNumber);
    final List<CustomCardTypeIcon> customCardTypeIcon = getCustomCardTypeIcon(ccType);
    if (customCardTypeIcon.isNotEmpty) {
      icon = customCardTypeIcon.first.cardImage;
      isAmex = ccType == CardType.americanExpress;
    } else {
      switch (ccType) {
        case CardType.visa:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = false;
          break;

        case CardType.americanExpress:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = true;
          break;

        case CardType.mastercard:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = false;
          break;

        case CardType.discover:
          icon = Image.asset(
            CardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
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
    }

    return icon;
  }

  List<CustomCardTypeIcon> getCustomCardTypeIcon(CardType currentCardType) =>
      widget.customCardTypeIcons
          .where((CustomCardTypeIcon element) =>
              element.cardType == currentCardType)
          .toList();
}

class MaskedTextController extends TextEditingController {
  MaskedTextController(
      {String? text, required this.mask, Map<String, RegExp>? translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (beforeChange(previous, this.text)) {
        updateText(this.text);
        afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  String mask;

  late Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text.isNotEmpty) {
      this.text = _applyMask(mask, text);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return <String, RegExp>{
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '@': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String? mask, String value) {
    String result = '';

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask!.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar]!.hasMatch(valueChar)) {
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
