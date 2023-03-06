import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeScannerView extends StatelessWidget {
  const NativeScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UiKitView(
      viewType: 'CreditCardScannerView',
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
