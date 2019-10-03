import 'package:flutter_credit_card/mask_text_controller.dart';

class CardField {
  const CardField({
    this.label,
    this.mask,
    this.controller,
  });

  final String label;
  final String mask;
  final MaskedTextController controller;
}
