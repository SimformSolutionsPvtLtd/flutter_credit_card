import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'credit_card_background.dart';
import 'flip_animation_builder.dart';
import 'float_animation_builder.dart';
import 'floating_animation/cursor_listener.dart';
import 'floating_animation/floating_config.dart';
import 'floating_animation/floating_controller.dart';
import 'floating_animation/floating_event.dart';
import 'models/credit_card_brand.dart';
import 'models/custom_card_type_icon.dart';
import 'models/glassmorphism_config.dart';
import 'plugin/flutter_credit_card_platform_interface.dart';
import 'utils/asset_paths.dart';
import 'utils/constants.dart';
import 'utils/enumerations.dart';
import 'utils/extensions.dart';
import 'utils/helpers.dart';
import 'utils/typedefs.dart';

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
    this.animationDuration = AppConstants.defaultAnimDuration,
    this.height,
    this.width,
    this.textStyle,
    this.cardBgColor = AppConstants.defaultCardBgColor,
    this.obscureCardNumber = true,
    this.obscureCardCvv = true,
    this.labelCardHolder = AppConstants.cardHolderCaps,
    this.labelExpiredDate = AppConstants.expiryDateShort,
    this.labelValidThru = AppConstants.validThru,
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
  final CCBrandChangeCallback onCreditCardWidgetChange;

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
    // TODO(aditya): Use AppLifecycleListener once Flutter 3.13 is the minimum support version.
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
          child: FlipAnimationBuilder(
            animation: _frontRotation,
            child: _buildFrontContainer(),
          ),
        ),
        _cardGesture(
          child: FlipAnimationBuilder(
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

  @override
  void dispose() {
    FlutterCreditCardPlatform.instance.dispose();
    controller.dispose();
    backCardFloatStream.close();
    frontCardFloatStream.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  void _processFloatingEvent(FloatingEvent? event) {
    if (!mounted || event == null || controller.isAnimating) {
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
                fontFamily: AppConstants.fontFamily,
                fontSize: 15,
                package: AppConstants.packageName,
              ),
            );

    String number = widget.cardNumber;
    if (widget.obscureCardNumber) {
      final String stripped = number.replaceAll(RegExp(r'[^\d]'), '');
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

    return FloatAnimationBuilder(
      isEnabled: widget.enableFloatingCard && isFrontVisible,
      stream: frontCardFloatStream.stream,
      onEvent: (FloatingEvent? event) =>
          floatController.transform(event, shouldAvoid: controller.isAnimating),
      child: () => _frontCardBackground(
        defaultTextStyle: defaultTextStyle,
        number: number,
      ),
    );
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
                      AssetPaths.chip,
                      package: AppConstants.packageName,
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
                widget.cardNumber.isEmpty ? AppConstants.sixteenX : number,
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
                _getCardTypeIcon(),
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
                fontFamily: AppConstants.fontFamily,
                fontSize: 16,
                package: AppConstants.packageName,
              ),
            );

    final String cvv = widget.obscureCardCvv
        ? widget.cvvCode.replaceAll(RegExp(r'\d'), '*')
        : widget.cvvCode;

    return FloatAnimationBuilder(
      isEnabled: widget.enableFloatingCard && !isFrontVisible,
      stream: backCardFloatStream.stream,
      onEvent: (FloatingEvent? event) =>
          floatController.transform(event, shouldAvoid: controller.isAnimating),
      child: () => _backCardBackground(
        defaultTextStyle: defaultTextStyle,
        cvv: cvv,
      ),
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
                                  ? AppConstants.fourX
                                  : AppConstants.threeX
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
                child: _getCardTypeIcon(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardGesture({required Widget child}) {
    bool isRightSwipe = true;
    double childHalfWidth = 0.0;
    return widget.isSwipeGestureEnabled
        ? GestureDetector(
            onTapUp: (TapUpDetails details) {
              isGestureUpdate = true;
              _toggleSide(
                flipFromRight: details.localPosition.dx > childHalfWidth,
              );
            },
            onPanEnd: (_) {
              isGestureUpdate = true;
              _toggleSide(flipFromRight: isRightSwipe);
            },
            onPanUpdate: (DragUpdateDetails details) =>
                isRightSwipe = !details.delta.dx.isNegative,
            child: LayoutBuilder(
              builder: (_, BoxConstraints constraints) {
                childHalfWidth = constraints.maxWidth / 2;
                return child;
              },
            ),
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

  Widget _getCardTypeIcon() {
    final CardType ccType = widget.cardType ?? detectCCType(widget.cardNumber);
    isAmex = ccType == CardType.americanExpress;
    return getCardTypeImage(
      cardType: ccType,
      customIcons: widget.customCardTypeIcons,
    );
  }
}
