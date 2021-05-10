part of '../tukanoid_styling.dart';

/// Class that is used for [Positioned] widget to define the position of a
/// [Widget] in a [Stack]
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

  /// Construct object from [PositionedStyling]
  /// [viewportSize] - size of the screen we take percentages of
  Position.fromStyling(PositionedStyling styling, Size viewportSize)
      : left = styling.leftVW * viewportSize.width,
        right = styling.rightVW * viewportSize.width,
        top = styling.topVH * viewportSize.height,
        bottom = styling.bottomVH * viewportSize.height,
        width = styling.widthVW * viewportSize.width,
        height = styling.heightVH * viewportSize.height;
}

/// Class for styling the [Position] class by utilizing percentage of the screen
/// size rather than set pixel size
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
