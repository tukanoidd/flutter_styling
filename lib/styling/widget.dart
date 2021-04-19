import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget margin(EdgeInsets margin) => Container(
    margin: margin,
    child: this,
  );
}