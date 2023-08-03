import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_scanner/core/scan_config.dart';
import 'package:flutter_credit_card/credit_card_scanner/models/credit_card_result.dart';

import '../widget/card_scanner_widget.dart';

class CreditCardScanner {
  factory CreditCardScanner() {
    return _creditCardScanner;
  }

  CreditCardScanner._() {
    _getCameraDescription();
  }

  static final CreditCardScanner _creditCardScanner = CreditCardScanner._();

  Future<void> _getCameraDescription() async {
    _cameraDescriptions = await availableCameras();
  }

  List<CameraDescription> _cameraDescriptions = <CameraDescription>[];

  Future<CreditCardFrontResult?> scan(
    BuildContext context, {
    ScanConfig scanConfig = const ScanConfig(),
  }) async {
     Navigator.of(context).push<CreditCardFrontResult?>(
      MaterialPageRoute<CreditCardFrontResult?>(
        builder: (_) => CardScannerWidget(
          cameraDescription: _cameraDescriptions[0],
          scanConfig: scanConfig,
        ),
      ),
    );
  }
}
