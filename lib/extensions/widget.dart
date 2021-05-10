part of '../tukanoid_styling.dart';

/// [Widget] extension helper functions
extension WidgetExtension on Widget {
  /// Wrap the widget in a container with margin
  Widget margin(EdgeInsets margin) => Container(
    margin: margin,
    child: this,
  );
}