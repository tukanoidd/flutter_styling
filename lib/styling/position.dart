part of '../tukanoid_styling.dart';

class Position {
  final double left;
  final double right;
  final double top;
  final double bottom;
  final double width;
  final double height;

  const Position({
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    required this.width,
    required this.height,
  });

  Position.fromStyling(PositionedStyling styling, Size viewportSize)
      : left = styling.leftVW * viewportSize.width,
        right = styling.rightVW * viewportSize.width,
        top = styling.topVH * viewportSize.height,
        bottom = styling.bottomVH * viewportSize.height,
        width = styling.widthVW * viewportSize.width,
        height = styling.heightVH * viewportSize.height;
}

class PositionedStyling {
  final double leftVW;
  final double rightVW;
  final double topVH;
  final double bottomVH;
  final double widthVW;
  final double heightVH;

  const PositionedStyling({
    this.leftVW = 0,
    this.rightVW = 0,
    this.topVH = 0,
    this.bottomVH = 0,
    this.widthVW = double.infinity,
    this.heightVH = double.infinity,
  });
}
