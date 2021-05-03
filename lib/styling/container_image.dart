part of '../tukanoid_styling.dart';

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

  Widget toWidget(Size viewportSize, {Widget? child}) {
    final double height = viewportSize.height;
    final double width = viewportSize.width;

    Widget widget;

    Size? size;

    if (useRatio && (heightVH != null || widthVW != null)) {
      if (heightVH != null) {
        final double h = heightVH! * height;
        size = Size(h * ratioWH, h);
      } else if (widthVW != null) {
        final double w = widthVW! * width;
        size = Size(w, w / ratioWH);
      }
    }

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

  ContainerImageStyling copyWithStyling(
          ContainerImageStyling newContainerImageStyling) =>
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
    File? newSVGFile,
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
        svgBytes: newSVGFile ?? svgBytes,
      );
}
