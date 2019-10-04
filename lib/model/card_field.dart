import 'package:flutter_masked_text/flutter_masked_text.dart';

class CardField {
  CardField({
    this.mask,
  }) : controller = MaskedTextController(mask: mask);

  final String mask;
  MaskedTextController controller;
}
