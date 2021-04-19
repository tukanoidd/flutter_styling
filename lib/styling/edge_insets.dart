import 'imports.dart';

class EdgeInsetsStyling {
  final double topVH;
  final double bottomVH;
  final double rightVW;
  final double leftVW;

  const EdgeInsetsStyling.zero()
      : topVH = 0,
        bottomVH = 0,
        leftVW = 0,
        rightVW = 0;

  const EdgeInsetsStyling.symmetric({
    double horizontalVW = 0.0,
    double verticalVH = 0.0,
  })  : topVH = verticalVH,
        bottomVH = verticalVH,
        rightVW = horizontalVW,
        leftVW = horizontalVW;

  const EdgeInsetsStyling.only({
    this.topVH = 0,
    this.bottomVH = 0,
    this.rightVW = 0,
    this.leftVW = 0,
  });

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