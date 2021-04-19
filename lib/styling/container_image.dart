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

  ContainerStyling With({
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
  final void Function()? onTap;
  final void Function(bool)? onHover;
  final Color? backgroundColor;
  final Color inkResponseHoverColor;
  final Color inkResponseHighlightColor;
  final Color inkResponseFocusColor;
  final Color inkResponseSplashColor;
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
    this.backgroundColor = Colors.grey,
    this.inkResponseHoverColor = Colors.transparent,
    this.inkResponseFocusColor = Colors.transparent,
    this.inkResponseHighlightColor = Colors.transparent,
    this.inkResponseSplashColor = Colors.transparent,
    this.fit = BoxFit.fill,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.scale = 1.0,
    this.ratioWH = 1.0,
    this.debugName,
    this.containerStyling,
    this.useRatio = false,
  });

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

    if (containerStyling != null || child != null || image == null) {
      widget = Container(
        width: size != null
            ? size.width
            : (widthVW != null ? widthVW! * width : null),
        height: size != null
            ? size.height
            : (heightVH != null ? heightVH! * height : null),
        padding: containerStyling!.paddingStyling?.toEdgeInsets(viewportSize),
        margin: containerStyling!.marginStyling?.toEdgeInsets(viewportSize),
        decoration: BoxDecoration(
          border: containerStyling!.border,
          borderRadius: containerStyling!.borderRadius,
          shape: containerStyling!.shape != null
              ? containerStyling!.shape!
              : BoxShape.rectangle,
          color: image == null ? backgroundColor : null,
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
    } else {
      widget = Image(
        image: image!,
        alignment: alignment,
        height: heightVH != null ? heightVH! * height : null,
        width: widthVW != null ? widthVW! * width : null,
        fit: fit,
        repeat: repeat,
      );
    }

    if (debugName != null) {
      print(debugName);
      print(widget);
      print('color: $backgroundColor');
      print('image: $image');
    }

    if (onTap != null || onHover != null) {
      widget = InkResponse(
        onTap: onTap ?? () {},
        onHover: onHover ?? (bool hovering) {},
        child: widget,
        highlightColor: inkResponseHighlightColor,
        hoverColor: inkResponseHoverColor,
        splashColor: inkResponseSplashColor,
        focusColor: inkResponseFocusColor,
      );
    }

    return widget;
  }

  ContainerImageStyling With({
    void Function()? newOnTap,
    Color? newBackgroundColor,
    ImageProvider? newImage,
    ContainerStyling? newContainerStyling,
  }) =>
      ContainerImageStyling(
        image: newImage ?? image,
        ratioWH: ratioWH,
        alignment: alignment,
        heightVH: heightVH,
        widthVW: widthVW,
        fit: fit,
        backgroundColor: newBackgroundColor ?? backgroundColor,
        scale: scale,
        repeat: repeat,
        inkResponseFocusColor: inkResponseFocusColor,
        inkResponseHighlightColor: inkResponseHighlightColor,
        inkResponseHoverColor: inkResponseHoverColor,
        inkResponseSplashColor: inkResponseSplashColor,
        onHover: onHover,
        onTap: newOnTap ?? onTap,
        debugName: debugName,
        containerStyling: newContainerStyling != null
            ? (containerStyling == null
                ? newContainerStyling
                : containerStyling!.With(
                    newMarginStyling: newContainerStyling.marginStyling,
                    newBorder: newContainerStyling.border,
                    newBorderRadius: newContainerStyling.borderRadius,
                    newPaddingStyling: newContainerStyling.paddingStyling,
                    newShape: newContainerStyling.shape,
                  ))
            : containerStyling,
        useRatio: useRatio,
      );
}
