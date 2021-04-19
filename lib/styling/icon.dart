import 'package:flutter/material.dart';

import '../styling.dart';

import 'imports.dart';

class TappableIcon extends StatefulWidget {
  final void Function()? onTap;
  final void Function(bool)? onHover;
  final bool animate;
  final Duration animationDuration;
  final IconStyling iconStyling;

  late final Color? color;
  late final Color? hoverColor;

  TappableIcon({
    Key? key,
    this.onTap,
    this.onHover,
    required this.iconStyling,
    this.animationDuration = const Duration(milliseconds: 300),
    this.color,
    this.hoverColor,
    this.animate = true,
  }) : super(key: key) {
    if (color == null) color = Colors.black;

    if (hoverColor == null) hoverColor = color;
  }

  @override
  _TappableIconState createState() => _TappableIconState();
}

class _TappableIconState extends State<TappableIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size viewportSize = MediaQuery.of(context).size;

    final Animation colorAnimationTween = ColorTween(
      begin: widget.color,
      end: widget.hoverColor,
    ).animate(_animationController);

    return InkResponse(
      onTap: widget.onTap ?? () {},
      onHover: (hovering) {
        if (hovering)
          _animationController.forward();
        else
          _animationController.reverse();

        if (widget.onHover != null) widget.onHover!(hovering);
      },
      hoverColor: Colors.transparent,
      child: widget.animate
          ? AnimatedBuilder(
              animation: colorAnimationTween,
              builder: (BuildContext context, Widget? child) => widget.iconStyling
                  .With(newColor: colorAnimationTween.value)
                  .toWidget(viewportSize),
            )
          : widget.iconStyling
          .With(newColor: widget.color)
          .toWidget(viewportSize),
    );
  }
}

class IconStyling {
  final IconData? icon;
  final double? iconSizeVH;
  final double? iconSizeVW;
  final Color color;
  final EdgeInsetsStyling? marginStyling;

  const IconStyling({
    this.icon,
    this.iconSizeVH,
    this.iconSizeVW,
    this.color = Colors.black,
    this.marginStyling,
  });

  /// Turn icon style into the widget
  ///
  /// [viewportHeight] - height to screen
  Widget toWidget(Size viewportSize, {String? debugName}) {
    Widget result = Icon(
      icon,
      color: color,
      size: iconSizeVH == null
          ? iconSizeVW! * viewportSize.width
          : iconSizeVH! * viewportSize.height,
    );

    if (marginStyling != null)
      result = result.margin(marginStyling!.toEdgeInsets(viewportSize));

    return result;
  }

  Widget button({
    void Function()? onTap,
    void Function(bool)? onHover,
    Color? color,
    Color? hoverColor,
    bool animate = true,
    Duration animationDuration = const Duration(milliseconds: 300),
  }) =>
      TappableIcon(
        iconStyling: this,
        color: color ?? this.color,
        hoverColor: hoverColor,
        onHover: onHover,
        onTap: onTap,
        animate: animate,
        animationDuration: animationDuration,
      );

  IconStyling With({
    Color? newColor,
    IconData? newIcon,
    EdgeInsetsStyling? newMarginStyling,
  }) =>
      IconStyling(
        iconSizeVH: iconSizeVH,
        icon: newIcon ?? icon,
        color: newColor ?? color,
        iconSizeVW: iconSizeVW,
        marginStyling: newMarginStyling ?? marginStyling,
      );
}
