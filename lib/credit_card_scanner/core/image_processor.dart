import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_credit_card/constants.dart';
import 'package:flutter_credit_card/credit_card_scanner/core/scan_config.dart';
import 'package:flutter_credit_card/credit_card_scanner/models/credit_card_result.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

typedef OnInputImageCallBack = Function(InputImage);

class ImageProcessor {
  ImageProcessor(this.scanConfig);

  late final ScanConfig scanConfig;

  final TextRecognizer _recognizer = TextRecognizer();

  final CreditCardFrontResult creditCardFrontResult = CreditCardFrontResult();
  final CreditCardResult creditCardBackResult = CreditCardBackResult();

  OnInputImageCallBack? onInputImage;

  // Future<void> startImageStream() async {
  //   if (!cameraController.value.isStreamingImages) {
  //     await cameraController.startImageStream(_createInputImageFromStream);
  //   }
  // }
  //
  // Future<void> stopImageStream() async {
  //   if (cameraController.value.isStreamingImages) {
  //     await cameraController.stopImageStream();
  //   }
  // }

  // void _createInputImageFromStream(CameraImage image) {
  //   final WriteBuffer writeBuffer = WriteBuffer();
  //   for (var plane in image.planes) {
  //     writeBuffer.putUint8List(plane.bytes);
  //   }
  //   final bytes = writeBuffer.done().buffer.asUint8List();
  //   final Size imageSize =
  //       Size(image.width.toDouble(), image.height.toDouble());
  //
  //   final imageRotation = InputImageRotationValue.fromRawValue(
  //     cameraDescription.sensorOrientation,
  //   );
  //   if (imageRotation == null) {
  //     return;
  //   }
  //
  //   final inputImageFormat =
  //       InputImageFormatValue.fromRawValue(image.format.raw);
  //   if (inputImageFormat == null) {
  //     return;
  //   }
  //   final planeData = image.planes.map(
  //     (Plane plane) {
  //       return InputImagePlaneMetadata(
  //         bytesPerRow: plane.bytesPerRow,
  //         height: plane.height,
  //         width: plane.width,
  //       );
  //     },
  //   ).toList();
  //
  //   final inputImageData = InputImageData(
  //     size: imageSize,
  //     imageRotation: imageRotation,
  //     inputImageFormat: inputImageFormat,
  //     planeData: planeData,
  //   );
  //   final inputImage = InputImage.fromBytes(
  //     bytes: bytes,
  //     inputImageData: inputImageData,
  //   );
  //
  //   onInputImage?.call(inputImage);
  //   //  processFrontImage(inputImage);
  // }

  Future<CreditCardFrontResult?> processFrontImage(InputImage inputImage) async {
    final recognizedText = await _recognizer.processImage(inputImage);

    if (recognizedText.blocks.isNotEmpty) {
      for (TextBlock block in recognizedText.blocks) {
        if (block.lines.isNotEmpty) {
          for (TextLine line in block.lines) {
            final text = line.text;

            creditCardFrontResult.cardNumber ??= _filterCardNumber(text);
            creditCardFrontResult.expiryDate ??= _filterExpiryDate(text);
            creditCardFrontResult.holderName ??= _filterCardHolder(text);
          }
        }
      }
    }

    if (scanConfig.requiresCardNum &&
        creditCardFrontResult.cardNumber == null) {
      return null;
    }
    if (scanConfig.requiresExpiryDate &&
        creditCardFrontResult.expiryDate == null) {
      return null;
    }
    if (scanConfig.requiresCardHolderName &&
        creditCardFrontResult.holderName == null) {
      return null;
    }

    return creditCardFrontResult;
  }

  String? _filterCardNumber(String text) {
    // Check if the line contains only digits, spaces, or dashes
    if (text.contains(AppConstants.lineSpaceDashRegExp)) {
      // Remove all spaces and dashes from the line
      final cleanText = text.replaceAll(AppConstants.spaceDashRegExp, '');

      // Check if the cleanText is a valid credit card number
      if (cleanText.contains(AppConstants.numberBetween12And19RegExp)) {
        return cleanText;
      }
    }
    return null;
  }

  String? _filterCardHolder(String text) {
    return null;
  }

  String? _filterExpiryDate(String text) {
    if (text.contains('/')) {
      final expiryDate = text.trim();
      return expiryDate;
    }
    return null;
  }

  void dispose() {
    _recognizer.close();
  }
}
