import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'credit_card_animation.dart';
import 'credit_card_background.dart';
import 'credit_card_brand.dart';
import 'custom_card_type_icon.dart';
import 'extension.dart';
import 'floating_animation/cursor_listener.dart';
import 'floating_animation/floating_config.dart';
import 'floating_animation/floating_controller.dart';
import 'floating_animation/floating_event.dart';
import 'flutter_credit_card_platform_interface.dart';
import 'glassmorphism_config.dart';

const Map<CardType, String> cardTypeIconAsset = <CardType, String>{
  CardType.visa: 'icons/visa.png',
  CardType.rupay: 'icons/rupay.png',
  CardType.americanExpress: 'icons/amex.png',
  CardType.mastercard: 'icons/mastercard.png',
  CardType.unionpay: 'icons/unionpay.png',
  CardType.discover: 'icons/discover.png',
  CardType.elo: 'icons/elo.png',
  CardType.hipercard: 'icons/hipercard.png',
};

class CreditCardWidget extends StatefulWidget {
  /// A widget showcasing credit card UI.
  const CreditCardWidget({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    required this.onCreditCardWidgetChange,
    this.bankName,
    this.animationDuration = const Duration(milliseconds: 500),
    this.height,
    this.width,
    this.textStyle,
    this.cardBgColor = const Color(0xff1b447b),
    this.obscureCardNumber = true,
    this.obscureCardCvv = true,
    this.labelCardHolder = 'CARD HOLDER',
    this.labelExpiredDate = 'MM/YY',
    this.labelValidThru = 'VALID\nTHRU',
    this.cardType,
    this.isHolderNameVisible = false,
    this.backgroundImage,
    this.backgroundNetworkImage,
    this.glassmorphismConfig,
    this.isChipVisible = true,
    this.isSwipeGestureEnabled = true,
    this.customCardTypeIcons = const <CustomCardTypeIcon>[],
    this.padding = AppConstants.creditCardPadding,
    this.chipColor,
    this.frontCardBorder,
    this.backCardBorder,
    this.obscureInitialCardNumber = false,
    this.enableFloatingCard = false,
    this.floatingConfig = const FloatingConfig(),
    super.key,
  });

  /// A string indicating number on the card.
  final String cardNumber;

  /// A string indicating expiry date for the card.
  final String expiryDate;

  /// A string indicating name of the card holder.
  final String cardHolderName;

  /// A String indicating cvv code.
  final String cvvCode;

  /// Applies text style to cardNumber, expiryDate, cardHolderName and cvvCode.
  final TextStyle? textStyle;

  /// Applies background color for card UI.
  final Color cardBgColor;

  /// Shows back side of the card at initial level when setting it to true.
  /// This is helpful when focusing on cvv.
  final bool showBackView;

  /// A string indicating name of the bank.
  final String? bankName;

  /// Duration for flip animation. Defaults to 500 milliseconds.
  final Duration animationDuration;

  /// Sets height of the front and back side of the card.
  final double? height;

  /// Sets width of the front and back side of the card.
  final double? width;

  /// If this flag is enabled then card number is replaced with obscuring
  /// characters to hide the content. Initial 4 and last 4 character
  /// doesn't get obscured. Defaults to true.
  final bool obscureCardNumber;

  /// Also obscures initial 4 card numbers with obscuring characters. This
  /// flag requires [obscureCardNumber] to be true. This flag defaults to false.
  final bool obscureInitialCardNumber;

  /// If this flag is enabled then cvv is replaced with obscuring characters
  /// to hide the content. Defaults to true.
  final bool obscureCardCvv;

  /// Provides a callback any time there is a change in credit card brand.
  final void Function(CreditCardBrand) onCreditCardWidgetChange;

  /// Enable/disable card holder name. Defaults to false.
  final bool isHolderNameVisible;

  /// Shows image as background of the card widget. This should be available
  /// locally in your assets folder.
  final String? backgroundImage;

  /// Shows image as background of the card widget from the network.
  final String? backgroundNetworkImage;

  /// Provides color to EMV chip on the card.
  final Color? chipColor;

  /// Enable/disable showcasing EMV chip UI. Defaults to true.
  final bool isChipVisible;

  /// Used to provide glassmorphism effect to credit card widget.
  final Glassmorphism? glassmorphismConfig;

  /// Enable/disable gestures on credit card widget. If enabled then flip
  /// animation is started when swiped or tapped. Defaults to true.
  final bool isSwipeGestureEnabled;

  /// Default label for card holder name. This is shown when user hasn't
  /// entered any text for card holder name.
  final String labelCardHolder;

  /// Default label for expiry date. This is shown when user hasn't entered any
  /// text for expiry date.
  final String labelExpiredDate;

  /// Default label for valid thru. This is shown when user hasn't entered any
  /// text for valid thru.
  final String labelValidThru;

  /// Sets type of the card. An small image is shown based on selected type
  /// of the card at bottom right corner. If this is set to null then image
  /// shown automatically based on credit card number.
  final CardType? cardType;

  /// Replaces credit card image with provided widget.
  final List<CustomCardTypeIcon> customCardTypeIcons;

  /// Provides equal padding inside the credit card widget in all directions.
  /// Defaults to 16.
  final double padding;

  /// Provides border in front of credit card widget.
  final BoxBorder? frontCardBorder;

  /// Provides border at back of credit card widget.
  final BoxBorder? backCardBorder;

  /// Denotes whether card floating animation is enabled.
  /// Defaults to false.
  ///
  /// Enabling this would float the card as per the movement of device or mouse
  /// pointer.
  final bool enableFloatingCard;

  /// The config for making the card float as per the movement of device or
  /// mouse pointer.
  final FloatingConfig floatingConfig;

  /// floating animation enabled/disabled
  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  late Gradient backgroundGradientColor;

  bool isFrontVisible = true;
  bool isGestureUpdate = false;
  bool isAmex = false;

  late FloatingShadowConfig? floatingShadowConfig =
      widget.enableFloatingCard && widget.floatingConfig.isShadowEnabled
          ? widget.floatingConfig.shadowConfig
          : null;

  final FloatingController floatController = FloatingController.predefined();

  final StreamController<FloatingEvent> frontCardFloatStream =
      StreamController<FloatingEvent>.broadcast();

  final StreamController<FloatingEvent> backCardFloatStream =
      StreamController<FloatingEvent>.broadcast();

  Orientation? orientation;
  Size? screenSize;

  /// Gives the radians pivoting opposite to the device movement with a center
  /// anchor point.
  double? get glarePosition => widget.enableFloatingCard &&
          widget.floatingConfig.isGlareEnabled
      ? pi / 4 + (floatController.y / floatController.maximumAngle * (2 * pi))
      : null;

  /// Represents the current floating card animation stream as per the
  /// visibility of the front or back side of the credit card.
  /// Determined based on [isFrontVisible].
  StreamController<FloatingEvent> get floatingCardStream =>
      isFrontVisible ? frontCardFloatStream : backCardFloatStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    ///initialize the animation controller
    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _handleFloatingAnimationSetup();
    _gradientSetup();
    _updateRotations(false);
  }

  @override
  void didChangeDependencies() {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    orientation = mediaQuery.orientation;
    screenSize = mediaQuery.size;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CreditCardWidget oldWidget) {
    if (widget.cardBgColor != oldWidget.cardBgColor) {
      _gradientSetup();
    }
    if (oldWidget.enableFloatingCard != widget.enableFloatingCard ||
        oldWidget.floatingConfig != widget.floatingConfig) {
      floatingShadowConfig =
          widget.enableFloatingCard && widget.floatingConfig.isShadowEnabled
              ? widget.floatingConfig.shadowConfig
              : null;
      _handleFloatingAnimationSetup();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        _handleFloatingAnimationSetup(shouldCancel: true);
        break;
      case AppLifecycleState.resumed:
        _handleFloatingAnimationSetup();
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
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
    FlutterCreditCardPlatform.instance.dispose();
    controller.dispose();
    backCardFloatStream.close();
    frontCardFloatStream.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    /// If user adds CVV then toggle the card from front to back.
    /// controller forward starts animation and shows back layout.
    /// controller reverse starts animation and shows front layout.
    ///
    if (isGestureUpdate) {
      isGestureUpdate = false;
    } else {
      _toggleSide(flipFromRight: false, showBackSide: widget.showBackView);
    }

    final CreditCardBrand cardBrand = CreditCardBrand(
      widget.cardType ?? detectCCType(widget.cardNumber),
    );
    widget.onCreditCardWidgetChange(cardBrand);

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
        if (widget.enableFloatingCard &&
            !FlutterCreditCardPlatform.instance.isGyroscopeAvailable)
          Positioned.fill(
            child: LayoutBuilder(
              builder: (_, BoxConstraints constraints) {
                final double parentHeight = constraints.maxHeight;
                final double parentWidth = constraints.maxWidth;
                final double outerPadding =
                    (screenSize?.width ?? parentWidth) - parentWidth;
                final double padding = outerPadding != 0 && widget.padding == 0
                    ? AppConstants.creditCardPadding
                    : widget.padding;

                return CursorListener(
                  onPositionChange: _processFloatingEvent,
                  height: parentHeight - padding,
                  width: parentWidth - padding,
                  padding: padding,
                );
              },
            ),
          )
      ],
    );
  }

  void _processFloatingEvent(FloatingEvent? event) {
    if (event == null || controller.isAnimating) {
      return;
    }

    floatingCardStream.add(event);
  }

  void _toggleSide({
    required bool flipFromRight,
    bool? showBackSide,
  }) {
    _updateRotations(flipFromRight);
    if (showBackSide ?? isFrontVisible) {
      isFrontVisible = false;
      controller.forward();
    } else {
      isFrontVisible = true;
      controller.reverse();
    }
  }

  void _updateRotations(bool isRightSwipe) {
    setState(() {
      final bool rotateToLeft = (isFrontVisible && !isRightSwipe) ||
          (!isFrontVisible && isRightSwipe);
      final double start = rotateToLeft ? (pi / 2) : (-pi / 2);
      final double end = rotateToLeft ? (-pi / 2) : (pi / 2);

      ///Initialize the Front to back rotation tween sequence.
      _frontRotation = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0.0, end: start)
                .chain(CurveTween(curve: Curves.linear)),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(end),
            weight: 50.0,
          ),
        ],
      ).animate(controller);

      ///Initialize the Back to Front rotation tween sequence.
      _backRotation = TweenSequence<double>(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(start),
            weight: 50.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: end, end: 0.0)
                .chain(CurveTween(curve: Curves.linear)),
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
        Theme.of(context).textTheme.titleLarge!.merge(
              const TextStyle(
                color: Colors.white,
                fontFamily: 'halter',
                fontSize: 15,
                package: 'flutter_credit_card',
              ),
            );

    String number = widget.cardNumber;
    if (widget.obscureCardNumber) {
      final String stripped = number.replaceAll(RegExp(r'\D'), '');
      if (widget.obscureInitialCardNumber && stripped.length > 4) {
        final String start = number
            .substring(0, number.length - 5)
            .trim()
            .replaceAll(RegExp(r'\d'), '*');
        number = '$start ${stripped.substring(stripped.length - 4)}';
      } else if (stripped.length > 8) {
        final String middle = number
            .substring(4, number.length - 5)
            .trim()
            .replaceAll(RegExp(r'\d'), '*');
        number =
            '${stripped.substring(0, 4)} $middle ${stripped.substring(stripped.length - 4)}';
      }
    }

    if (widget.enableFloatingCard && isFrontVisible) {
      return StreamBuilder<FloatingEvent>(
        stream: frontCardFloatStream.stream,
        builder: (BuildContext context, AsyncSnapshot<FloatingEvent> snapshot) {
          return Transform(
            transform: floatController.transform(
              snapshot.data,
              shouldAvoid: controller.isAnimating,
            ),
            alignment: FractionalOffset.center,
            child: _frontCardBackground(
              defaultTextStyle: defaultTextStyle,
              number: number,
            ),
          );
        },
      );
    } else {
      return _frontCardBackground(
        defaultTextStyle: defaultTextStyle,
        number: number,
      );
    }
  }

  Widget _frontCardBackground({
    required String number,
    required TextStyle defaultTextStyle,
  }) {
    return CardBackground(
      glarePosition: glarePosition,
      floatingController: widget.enableFloatingCard ? floatController : null,
      backgroundImage: widget.backgroundImage,
      backgroundNetworkImage: widget.backgroundNetworkImage,
      backgroundGradientColor: backgroundGradientColor,
      glassmorphismConfig: widget.glassmorphismConfig,
      height: widget.height,
      width: widget.width,
      padding: widget.padding,
      border: widget.frontCardBorder,
      shadowConfig: floatingShadowConfig,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.bankName.isNotNullAndNotEmpty)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: Text(
                  widget.bankName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: defaultTextStyle,
                ),
              ),
            ),
          Expanded(
            flex: widget.isChipVisible ? 1 : 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (widget.isChipVisible)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16),
                    child: Image.asset(
                      'icons/chip.png',
                      package: 'flutter_credit_card',
                      color: widget.chipColor,
                      scale: 1,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Text(
                widget.cardNumber.isEmpty ? 'XXXX XXXX XXXX XXXX' : number,
                style: widget.textStyle ?? defaultTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.labelValidThru,
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
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Visibility(
                  visible: widget.isHolderNameVisible,
                  child: Expanded(
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
                widget.cardType != null
                    ? getCardTypeImage(widget.cardType)
                    : getCardTypeIcon(widget.cardNumber),
              ],
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
        Theme.of(context).textTheme.titleLarge!.merge(
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

    return widget.enableFloatingCard && !isFrontVisible
        ? StreamBuilder<FloatingEvent>(
            stream: backCardFloatStream.stream,
            builder:
                (BuildContext context, AsyncSnapshot<FloatingEvent> snapshot) {
              return Transform(
                transform: floatController.transform(
                  snapshot.data,
                  shouldAvoid: controller.isAnimating,
                ),
                alignment: FractionalOffset.center,
                child: _backCardBackground(
                  cvv: cvv,
                  defaultTextStyle: defaultTextStyle,
                ),
              );
            },
          )
        : _backCardBackground(
            cvv: cvv,
            defaultTextStyle: defaultTextStyle,
          );
  }

  Widget _backCardBackground({
    required String cvv,
    required TextStyle defaultTextStyle,
  }) {
    return CardBackground(
      glarePosition: glarePosition,
      floatingController: widget.enableFloatingCard ? floatController : null,
      backgroundImage: widget.backgroundImage,
      backgroundNetworkImage: widget.backgroundNetworkImage,
      backgroundGradientColor: backgroundGradientColor,
      glassmorphismConfig: widget.glassmorphismConfig,
      height: widget.height,
      width: widget.width,
      padding: widget.padding,
      border: widget.backCardBorder,
      shadowConfig: floatingShadowConfig,
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
              _toggleSide(flipFromRight: isRightSwipe);
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

  void _handleFloatingAnimationSetup({bool? shouldCancel}) {
    if (shouldCancel ?? !widget.enableFloatingCard) {
      FlutterCreditCardPlatform.instance.dispose();
      return;
    }

    FlutterCreditCardPlatform.instance.initialize().then((_) {
      final bool isGyroAvailable =
          FlutterCreditCardPlatform.instance.isGyroscopeAvailable;
      floatController.isGyroscopeAvailable = isGyroAvailable;

      if (isGyroAvailable) {
        FlutterCreditCardPlatform.instance.floatingStream
            ?.listen(_processFloatingEvent);
      }
    });
  }

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  Map<CardType, Set<List<String>>> cardNumPatterns =
      <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.rupay: <List<String>>{
      <String>['60'],
      <String>['6521'],
      <String>['6522'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.unionpay: <List<String>>{
      <String>['62'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'], // China UnionPay co-branded
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
    CardType.elo: <List<String>>{
      <String>['401178'],
      <String>['401179'],
      <String>['438935'],
      <String>['457631'],
      <String>['457632'],
      <String>['431274'],
      <String>['451416'],
      <String>['457393'],
      <String>['504175'],
      <String>['506699', '506778'],
      <String>['509000', '509999'],
      <String>['627780'],
      <String>['636297'],
      <String>['636368'],
      <String>['650031', '650033'],
      <String>['650035', '650051'],
      <String>['650405', '650439'],
      <String>['650485', '650538'],
      <String>['650541', '650598'],
      <String>['650700', '650718'],
      <String>['650720', '650727'],
      <String>['650901', '650978'],
      <String>['651652', '651679'],
      <String>['655000', '655019'],
      <String>['655021', '655058']
    },
    CardType.hipercard: <List<String>>{
      <String>['606282'],
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
    final List<CustomCardTypeIcon> customCardTypeIcon =
        getCustomCardTypeIcon(cardType!);
    if (customCardTypeIcon.isNotEmpty) {
      return customCardTypeIcon.first.cardImage;
    } else {
      return Image.asset(
        cardTypeIconAsset[cardType]!,
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
    final List<CustomCardTypeIcon> customCardTypeIcon =
        getCustomCardTypeIcon(ccType);
    if (customCardTypeIcon.isNotEmpty) {
      icon = customCardTypeIcon.first.cardImage;
      isAmex = ccType == CardType.americanExpress;
    } else {
      switch (ccType) {
        case CardType.visa:
        case CardType.rupay:
        case CardType.unionpay:
        case CardType.discover:
        case CardType.mastercard:
        case CardType.elo:
        case CardType.hipercard:
          icon = Image.asset(
            cardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = false;
          break;

        case CardType.americanExpress:
          icon = Image.asset(
            cardTypeIconAsset[ccType]!,
            height: 48,
            width: 48,
            package: 'flutter_credit_card',
          );
          isAmex = true;
          break;

        default:
          icon = const SizedBox(height: 48, width: 48);
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
  rupay,
  americanExpress,
  unionpay,
  discover,
  elo,
  hipercard,
}
