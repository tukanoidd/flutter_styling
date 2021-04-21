part of '../tukanoid_styling.dart';

class DividerStyling {
  final double heightVH;
  final Color color;
  final double endIndentVW;
  final double indentVW;
  final double thicknessVH;

  DividerStyling(
      {
        required this.heightVH,
        this.color = Colors.black,
        required this.endIndentVW,
        required this.indentVW,
        required this.thicknessVH,
      });

  Divider toWidget(Size viewportSize) {
    final double width = viewportSize.width;
    final double height = viewportSize.height;

    return Divider(
      height: heightVH * height,
      color: color,
      endIndent: endIndentVW * width,
      indent: indentVW * width,
      thickness: thicknessVH * height,
    );
  }
}

class VerticalDividerStyling {
  final Color color;
  final double thicknessVW;
  final double indentVH;
  final double endIndentVH;
  final double widthVW;

  const VerticalDividerStyling({
    this.color = Colors.black,
    required this.thicknessVW,
    required this.indentVH,
    required this.endIndentVH,
    required this.widthVW,
  });

  /// Turn the style into the VerticalDivider widget
  ///
  /// [viewportSize] - Size of the screen
  VerticalDivider toWidget(Size viewportSize) {
    final double width = viewportSize.width;
    final double height = viewportSize.height;

    return VerticalDivider(
      color: color,
      thickness: thicknessVW * width,
      indent: indentVH * height,
      endIndent: endIndentVH * height,
      width: widthVW * width,
    );
  }
}