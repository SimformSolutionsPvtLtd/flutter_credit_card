import 'dart:math';

import 'package:flutter/rendering.dart';

import 'asset_paths.dart';
import 'enumerations.dart';

class AppConstants {
  const AppConstants._();

  static const String packageName = 'flutter_credit_card';
  static const String fontFamily = 'halter';

  static const String threeX = 'XXX';
  static const String fourX = 'XXXX';
  static const String sixteenX = 'XXXX XXXX XXXX XXXX';
  static const String cardNumberMask = '0000 0000 0000 0000';
  static const String expiryDateMask = '00/00';
  static const String cvvMask = '0000';
  static const String cvv = 'CVV';
  static const String cardHolderCaps = 'CARD HOLDER';
  static const String cardHolder = 'Card Holder';
  static const String cardNumber = 'Card Number';
  static const String expiryDate = 'Expiry Date';
  static const String expiryDateShort = 'MM/YY';
  static const String validThru = 'VALID\nTHRU';
  static const String cvvValidationMessage = 'Please input a valid CVV';
  static const String dateValidationMessage = 'Please input a valid date';
  static const String numberValidationMessage = 'Please input a valid number';

  static const double floatWebBreakPoint = 650;
  static const double creditCardAspectRatio = 0.5714;
  static const double creditCardPadding = 16;
  static const double creditCardIconSize = 48;
  static const BorderRadius creditCardBorderRadius = BorderRadius.all(
    Radius.circular(10),
  );

  static const double minRestBackVel = 0.01;
  static const double maxRestBackVel = 0.05;
  static const double defaultRestBackVel = 0.8;

  static const Duration fps60 = Duration(microseconds: 16666);
  static const Duration fps60Offset = Duration(microseconds: 16667);
  static const Duration defaultAnimDuration = Duration(milliseconds: 500);

  /// Color constants
  static const Color defaultGlareColor = Color(0xffFFFFFF);
  static const Color floatingShadowColor = Color(0x4D000000);
  static const Color defaultCardBgColor = Color(0xff1b447b);

  static const double defaultMaximumAngle = pi / 10;
  static const double minBlurRadius = 10;

  /// Gyroscope channel constants
  static const String gyroMethodChannelName = 'com.simform.flutter_credit_card';
  static const String gyroEventChannelName =
      'com.simform.flutter_credit_card/gyroscope';
  static const String isGyroAvailableMethod = 'isGyroscopeAvailable';
  static const String initiateMethod = 'initiateEvents';
  static const String cancelMethod = 'cancelEvents';

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  static const Map<CardType, Set<List<String>>> cardNumPatterns =
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

  static const Map<CardType, String> cardTypeIconAsset = <CardType, String>{
    CardType.visa: AssetPaths.visa,
    CardType.rupay: AssetPaths.rupay,
    CardType.americanExpress: AssetPaths.americanExpress,
    CardType.mastercard: AssetPaths.mastercard,
    CardType.unionpay: AssetPaths.unionpay,
    CardType.discover: AssetPaths.discover,
    CardType.elo: AssetPaths.elo,
    CardType.hipercard: AssetPaths.hipercard,
  };
}
