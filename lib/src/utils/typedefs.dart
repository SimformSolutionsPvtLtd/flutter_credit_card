import 'package:flutter/widgets.dart';

import '../floating_animation/floating_event.dart';
import '../models/credit_card_brand.dart';
import '../models/credit_card_model.dart';

typedef CCModelChangeCallback = void Function(CreditCardModel);

typedef CCBrandChangeCallback = void Function(CreditCardBrand);

typedef ValidationCallback = String? Function(String?);

typedef FloatEventCallback = Matrix4 Function(FloatingEvent? event);

typedef WidgetCallback = Widget Function();
