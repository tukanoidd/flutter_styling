part of '../tukanoid_styling.dart';

/// Class for styling container-specific attributes, used mostly in
/// [ContainerImageStyling]
class ContainerStyling {
  final BorderRadius? borderRadius;
  final BoxShape? shape;
  final EdgeInsetsStyling? paddingStyling;
  final EdgeInsetsStyling? marginStyling;
  final Border? border;

  ContainerStyling({
    this.borderRadius,
    this.shape,
    this.paddingStyling,
    this.marginStyling,
    this.border,
  });

  /// Creates a copy of the [ContainerStyling] object by overriding members if
  /// new optional values are not null
  ContainerStyling copyWith({
    BorderRadius? newBorderRadius,
    BoxShape? newShape,
    EdgeInsetsStyling? newPaddingStyling,
    EdgeInsetsStyling? newMarginStyling,
    Border? newBorder,
  }) =>
      ContainerStyling(
        paddingStyling: newPaddingStyling ?? paddingStyling,
        marginStyling: newMarginStyling ?? marginStyling,
        borderRadius: newBorderRadius ?? borderRadius,
        border: newBorder ?? border,
        shape: newShape ?? shape,
      );
}

/// Class used for styling both [Image] and [Container] widgets, since both can
/// use [ImageProvider] as background image source ([Container]) or as just
/// image source ([Image])
class ContainerImageStyling {
  final double? widthVW;
  final double? heightVH;
  ImageProvider? image;
  Uint8List? svgBytes;
  final void Function()? onTap;
  final void Function(bool)? onHover;
  final Color? backgroundColor;
  final Color? inkResponseHoverColor;
  final Color? inkResponseHighlightColor;
  final Color? inkResponseFocusColor;
  final Color? inkResponseSplashColor;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final double scale;
  final double ratioWH;
  final String? debugName;
  final ContainerStyling? containerStyling;
  final bool useRatio;

  ContainerImageStyling({
    this.widthVW,
    this.heightVH,
    this.image,
    this.onTap,
    this.onHover,
    this.backgroundColor,
    this.inkResponseHoverColor,
    this.inkResponseFocusColor,
    this.inkResponseHighlightColor,
    this.inkResponseSplashColor,
    this.fit = BoxFit.fill,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.scale = 1.0,
    this.ratioWH = 1.0,
    this.debugName,
    this.containerStyling,
    this.useRatio = false,
    this.svgBytes,
  });

  /// Private function that lets you build a container with the member values
  /// [size] - the size of the container
  /// [viewportSize] - screen size that we are taking percentages of
  /// [child] - optional child [Widget] that we add to the container if needed
  Widget _buildContainer(Size? size, Size viewportSize, Widget? child) {
    final double width = viewportSize.width;
    final double height = viewportSize.height;

    return Container(
      width: size != null
          ? size.width
          : (widthVW != null ? widthVW! * width : null),
      height: size != null
          ? size.height
          : (heightVH != null ? heightVH! * height : null),
      padding: containerStyling?.paddingStyling?.toEdgeInsets(viewportSize),
      margin: containerStyling?.marginStyling?.toEdgeInsets(viewportSize),
      decoration: BoxDecoration(
        border: containerStyling?.border,
        borderRadius: containerStyling?.borderRadius,
        shape: containerStyling != null
            ? (containerStyling!.shape != null
                ? containerStyling!.shape!
                : BoxShape.rectangle)
            : BoxShape.rectangle,
        color: image == null ? (backgroundColor ?? Colors.grey) : null,
        image: image != null
            ? DecorationImage(
                image: image!,
                alignment: alignment,
                fit: fit,
                repeat: repeat,
                scale: scale,
              )
            : null,
      ),
      alignment: alignment,
      child: child,
    );
  }

  /// Create a [Widget] based on this styling data
  /// [viewportSize] - size of the screen we're taking percentages of
  /// [child] - optional child to add to the container if there is one
  Widget toWidget(Size viewportSize, {Widget? child}) {
    final double height = viewportSize.height;
    final double width = viewportSize.width;

    Widget widget;

    Size? size;

    // If we use [ratioWH] for the sizing and at least on of the sizes is defined,
    // initialize the values of the [size] variable
    if (useRatio && (heightVH != null || widthVW != null)) {
      if (heightVH != null) {
        final double h = heightVH! * height;
        size = Size(h * ratioWH, h);
      } else if (widthVW != null) {
        final double w = widthVW! * width;
        size = Size(w, w / ratioWH);
      }
    }

    // If there are any container specific members that are not null, build a
    // container with optional child [Widget] as well
    // If not, check if [image] or [svgBytes] are not null ti create their
    // respective [Widget]s and if both are null while there are still no
    // container-specific parameters initialized, build an empty container
    if (containerStyling != null ||
        child != null ||
        (image == null && svgBytes == null)) {
      widget = _buildContainer(size, viewportSize, child);
    } else {
      if (image != null)
        widget = Image(
          image: image!,
          alignment: alignment,
          height: heightVH != null ? heightVH! * height : null,
          width: widthVW != null ? widthVW! * width : null,
          fit: fit,
          repeat: repeat,
        );
      else if (svgBytes != null)
        widget = SvgPicture.memory(
          svgBytes!,
          height: heightVH != null ? heightVH! * height : null,
          width: widthVW != null ? widthVW! * width : null,
          fit: fit,
        );
      else
        widget = _buildContainer(size, viewportSize, child);
    }

    // If there are any gestures set, wrap the image/container in gesture
    // detector (int this case [InkResponse])
    if (onTap != null || onHover != null) {
      widget = InkResponse(
        onTap: onTap ?? () {},
        onHover: onHover ?? (bool hovering) {},
        child: widget,
        highlightColor: inkResponseHighlightColor ?? Colors.transparent,
        hoverColor: inkResponseHoverColor ?? Colors.transparent,
        splashColor: inkResponseSplashColor ?? Colors.transparent,
        focusColor: inkResponseFocusColor ?? Colors.transparent,
      );
    }

    return widget;
  }

  /// Creates a copy of the [ContainerStyling] object by overriding members if
  /// new optional values are not null, calls [copyWith] with providing all the
  /// values from the given new [ContainerImageStyling] object
  ContainerImageStyling copyWithStyling(
    ContainerImageStyling newContainerImageStyling,
  ) =>
      copyWith(
        newContainerStyling: newContainerImageStyling.containerStyling,
        newOnTap: newContainerImageStyling.onTap,
        newBackgroundColor: newContainerImageStyling.backgroundColor,
        newImage: newContainerImageStyling.image,
        newAlignment: newContainerImageStyling.alignment,
        newDebugName: newContainerImageStyling.debugName,
        newFit: newContainerImageStyling.fit,
        newHeightVH: newContainerImageStyling.heightVH,
        newInkResponseFocusColor:
            newContainerImageStyling.inkResponseFocusColor,
        newInkResponseHighlightColor:
            newContainerImageStyling.inkResponseHighlightColor,
        newInkResponseHoverColor:
            newContainerImageStyling.inkResponseHoverColor,
        newInkResponseSplashColor:
            newContainerImageStyling.inkResponseSplashColor,
        newOnHover: newContainerImageStyling.onHover,
        newRatioWH: newContainerImageStyling.ratioWH,
        newRepeat: newContainerImageStyling.repeat,
        newScale: newContainerImageStyling.scale,
        newUseRation: newContainerImageStyling.useRatio,
        newWidthVW: newContainerImageStyling.widthVW,
      );

  /// Creates a copy of the [ContainerImageStyling] object by overriding members if
  /// new optional values are not null
  ContainerImageStyling copyWith({
    void Function()? newOnTap,
    Color? newBackgroundColor,
    ImageProvider? newImage,
    ContainerStyling? newContainerStyling,
    double? newRatioWH,
    AlignmentGeometry? newAlignment,
    double? newHeightVH,
    double? newWidthVW,
    BoxFit? newFit,
    double? newScale,
    ImageRepeat? newRepeat,
    Color? newInkResponseFocusColor,
    Color? newInkResponseHighlightColor,
    Color? newInkResponseHoverColor,
    Color? newInkResponseSplashColor,
    void Function(bool)? newOnHover,
    String? newDebugName,
    bool? newUseRation,
    Uint8List? newSVGBytes,
  }) =>
      ContainerImageStyling(
        image: newImage ?? image,
        ratioWH: newRatioWH ?? ratioWH,
        alignment: newAlignment ?? alignment,
        heightVH: newHeightVH ?? heightVH,
        widthVW: newWidthVW ?? widthVW,
        fit: newFit ?? fit,
        backgroundColor: newBackgroundColor ?? backgroundColor,
        scale: newScale ?? scale,
        repeat: newRepeat ?? repeat,
        inkResponseFocusColor:
            newInkResponseFocusColor ?? inkResponseFocusColor,
        inkResponseHighlightColor:
            newInkResponseHighlightColor ?? inkResponseHighlightColor,
        inkResponseHoverColor:
            newInkResponseHoverColor ?? inkResponseHoverColor,
        inkResponseSplashColor:
            newInkResponseSplashColor ?? inkResponseSplashColor,
        onHover: newOnHover ?? onHover,
        onTap: newOnTap ?? onTap,
        debugName: newDebugName ?? debugName,
        containerStyling: newContainerStyling != null
            ? (containerStyling == null
                ? newContainerStyling
                : containerStyling?.copyWith(
                    newMarginStyling: newContainerStyling.marginStyling,
                    newBorder: newContainerStyling.border,
                    newBorderRadius: newContainerStyling.borderRadius,
                    newPaddingStyling: newContainerStyling.paddingStyling,
                    newShape: newContainerStyling.shape,
                  ))
            : containerStyling,
        useRatio: newUseRation ?? useRatio,
        svgBytes: newSVGBytes ?? svgBytes,
      );
}
