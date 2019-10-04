import 'package:flutter/widgets.dart';

Size size(BuildContext context) => MediaQuery.of(context).size;
Orientation orientation(BuildContext context) =>
    MediaQuery.of(context).orientation;
