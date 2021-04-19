part of '../tukanoid_styling.dart';

extension WidgetExtension on Widget {
  Widget margin(EdgeInsets margin) => Container(
    margin: margin,
    child: this,
  );
}