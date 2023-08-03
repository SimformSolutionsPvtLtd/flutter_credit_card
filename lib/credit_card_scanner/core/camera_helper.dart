import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

typedef OnInputImageCallBack = Function(InputImage);

class CameraHelper {
  CameraHelper({
    required this.cameraDescription,
    required this.onCameraControllerInitialised,
    this.onInputImage,
  }) {
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
    );
    cameraController.initialize().then((value) {
      onCameraControllerInitialised.call();
    });
  }

  late final CameraController cameraController;
  late final CameraDescription cameraDescription;
  late final VoidCallback onCameraControllerInitialised;

  bool isStreamStopped = false;
  OnInputImageCallBack? onInputImage;

  Future<void> startImageStream() async {
    isStreamStopped = false;
    if (!cameraController.value.isStreamingImages) {
      await cameraController.startImageStream(_createInputImageFromStream);
    }
  }

  Future<void> stopImageStream() async {
    isStreamStopped = true;
    if (cameraController.value.isStreamingImages) {
      await cameraController.stopImageStream();
    }
  }

  void _createInputImageFromStream(CameraImage image) {
    if (isStreamStopped) {
      return;
    }
    final WriteBuffer writeBuffer = WriteBuffer();
    for (var plane in image.planes) {
      writeBuffer.putUint8List(plane.bytes);
    }
    final bytes = writeBuffer.done().buffer.asUint8List();
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final imageRotation = InputImageRotationValue.fromRawValue(
      cameraDescription.sensorOrientation,
    );
    if (imageRotation == null) {
      return;
    }

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) {
      return;
    }
    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    onInputImage?.call(inputImage);
  }

  void dispose() {
    cameraController.dispose();
  }
}
