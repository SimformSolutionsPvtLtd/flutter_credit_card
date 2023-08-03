import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_scanner/core/camera_helper.dart';

import 'package:flutter_credit_card/credit_card_scanner/core/image_processor.dart';
import 'package:flutter_credit_card/credit_card_scanner/core/scan_config.dart';
import 'package:flutter_credit_card/credit_card_scanner/models/credit_card_result.dart';

class CardScannerWidget extends StatefulWidget {
  const CardScannerWidget({
    Key? key,
    required this.cameraDescription,
    required this.scanConfig,
  }) : super(key: key);
  final CameraDescription cameraDescription;
  final ScanConfig scanConfig;

  @override
  State<CardScannerWidget> createState() => _CardScannerWidgetState();
}

class _CardScannerWidgetState extends State<CardScannerWidget> {
  late CameraHelper cameraHelper;

  late ImageProcessor imageProcessor;
  bool hasResult = false;
  bool isPopped = false;
  CreditCardFrontResult? result;

  @override
  void initState() {
    super.initState();
    imageProcessor = ImageProcessor(widget.scanConfig);
    cameraHelper = CameraHelper(
      cameraDescription: widget.cameraDescription,
      onCameraControllerInitialised: () {
        setState(() {});
      },
      onInputImage: (inputImage) async {
        if (!hasResult) {
          final creditCardResult =
              await imageProcessor.processFrontImage(inputImage);
          if (creditCardResult != null) {
            hasResult = true;
            print('hasResult -> $hasResult');
            result = creditCardResult;
            await cameraHelper.stopImageStream();
            popIfMounted(creditCardResult);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (cameraHelper.cameraController.value.isInitialized)
            CameraPreview(cameraHelper.cameraController),
          _overlay,
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              onPressed: () {
                cameraHelper.startImageStream();
              },
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: IconButton(
              onPressed: () {
                cameraHelper.stopImageStream();
              },
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _overlay {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        backgroundBlendMode: BlendMode.dstOut,
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.57,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blueAccent,
                width: 3,
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.57,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    cameraHelper.dispose();
    imageProcessor.dispose();
    super.dispose();
  }

  void popIfMounted(CreditCardResult? creditCardResult) {
    print(creditCardResult);
    if (isPopped) {
      if (mounted) {
        Navigator.pop(context, creditCardResult);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pop(context, creditCardResult);
          }
        });
      }
    }
    isPopped = true;
  }
}
