part of '../tukanoid_styling.dart';

/// Class for making [EdgeInsets] be dependent on screen size percentage rather
/// than set pixel value
class EdgeInsetsStyling {
  final double topVH;
  final double bottomVH;
  final double rightVW;
  final double leftVW;

  /// Construct the object with all members being 0
  const EdgeInsetsStyling.zero()
      : topVH = 0,
        bottomVH = 0,
        leftVW = 0,
        rightVW = 0;

  /// Construct the object with symmetric values, same for
  /// [topVH]&[bottomVH] ([verticalVH]) and [leftVW]&[rightVW] ([horizontalVW])
  const EdgeInsetsStyling.symmetric({
    double horizontalVW = 0.0,
    double verticalVH = 0.0,
  })  : topVH = verticalVH,
        bottomVH = verticalVH,
        rightVW = horizontalVW,
        leftVW = horizontalVW;

  /// Construct the object by setting each member individually
  const EdgeInsetsStyling.only({
    this.topVH = 0,
    this.bottomVH = 0,
    this.rightVW = 0,
    this.leftVW = 0,
  });

  /// Convert this screen size dependent [EdgeInsets] into set pixel size one
  /// [viewportSize] - size of the screen
  EdgeInsets toEdgeInsets(Size viewportSize) {
    final double height = viewportSize.height;
    final double width = viewportSize.width;

    return EdgeInsets.only(
      top: topVH * height,
      bottom: bottomVH * height,
      left: leftVW * width,
      right: rightVW * width,
    );
  }
}