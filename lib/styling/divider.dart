import 'imports.dart';

class VerticalDividerStyle {
  final Color color;
  final double thicknessVW;
  final double indentVH;
  final double endIndentVH;
  final double widthVW;

  const VerticalDividerStyle({
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