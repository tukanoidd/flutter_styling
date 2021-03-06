part of '../tukanoid_styling.dart';

/// Class that makes [Text] or [AutoSizeText] widget tappable by using
/// [InkResponse] as a wrapper for gesture detection
class TappableText extends StatefulWidget {
  final void Function() onTap;
  final void Function(bool)? onHover;
  final bool hoverUnderline;
  final TextStyling childTextStyling;
  final String text;
  final Color? hoverColor;
  final Color? focusColor;
  final Color? splashColor;
  final Color? highlightColor;
  final bool alwaysUnderline;

  const TappableText({
    Key? key,
    required this.onTap,
    this.onHover,
    this.hoverUnderline = true,
    required this.childTextStyling,
    required this.text,
    this.hoverColor,
    this.focusColor,
    this.splashColor,
    this.highlightColor,
    this.alwaysUnderline = false,
  }) : super(key: key);

  @override
  _TappableTextState createState() => _TappableTextState();
}

class _TappableTextState extends State<TappableText> {
  final Color defaultColor = Colors.transparent;

  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Size viewportSize = MediaQuery.of(context).size;

    return InkResponse(
      onTap: widget.onTap,
      onHover: (hovering) {
        setState(() => _isHovering = hovering);

        if (widget.onHover != null) widget.onHover!(hovering);
      },
      hoverColor: widget.hoverColor ?? defaultColor,
      focusColor: widget.focusColor ?? defaultColor,
      splashColor: widget.splashColor ?? defaultColor,
      highlightColor: widget.highlightColor ?? defaultColor,
      child: widget.childTextStyling
          .copyWith(
            newDecoration: widget.alwaysUnderline
                ? TextDecoration.underline
                : (widget.hoverUnderline
                    ? (_isHovering
                        ? TextDecoration.underline
                        : TextDecoration.none)
                    : TextDecoration.none),
          )
          .container(
            widget.text,
            viewportSize,
          ),
    );
  }
}

/// Class used for styling a [Text] or [AutoSizeText] widget
class TextStyling {
  final double? textContainerVH;
  final double? textContainerVW;
  final String? fontFamily;
  final double fontSizeVH;
  final FontWeight fontWeight;
  Color textColor;
  final TextAlign textAlignment;
  final TextOverflow overflow;
  final Alignment containerAlignment;
  final TextDecoration decoration;
  final EdgeInsetsStyling? paddingStyling;
  final EdgeInsetsStyling? marginStyling;
  final int maxLines;
  final bool autoSize;
  final FontStyle fontStyle;

  TextStyling({
    this.textContainerVH,
    this.textContainerVW,
    this.fontFamily,
    required this.fontSizeVH,
    this.fontWeight = FontWeight.w400,
    this.textColor = Colors.black,
    this.textAlignment = TextAlign.center,
    this.overflow = TextOverflow.visible,
    this.containerAlignment = Alignment.center,
    this.decoration = TextDecoration.none,
    this.marginStyling,
    this.paddingStyling,
    this.maxLines = 1,
    this.autoSize = true,
    this.fontStyle = FontStyle.normal,
  });

  /// Turn styling data into Google font
  /// [viewportHeight] - Screen Height
  TextStyle toTextStyle(double viewportHeight) => GoogleFonts.getFont(
        fontFamily ?? Styling.globalFontFamily,
        fontSize: fontSizeVH * viewportHeight,
        fontWeight: fontWeight,
        color: textColor,
        decoration: decoration,
        fontStyle: FontStyle.normal,
      );

  /// Create container around the Text widget
  /// [text] - text of the widget
  /// [viewportSize] - screen size
  Widget container(String text, Size viewportSize) {
    Widget result = autoSize
        ? AutoSizeText(
            text,
            style: toTextStyle(viewportSize.height),
            textAlign: textAlignment,
            overflow: TextOverflow.visible,
            maxLines: maxLines > 0 ? maxLines : null,
          )
        : Text(
            text,
            style: toTextStyle(viewportSize.height),
            textAlign: textAlignment,
            overflow: TextOverflow.visible,
            maxLines: maxLines > 0 ? maxLines : null,
          );

    if (textContainerVH != null ||
        textContainerVW != null ||
        paddingStyling != null ||
        marginStyling != null)
      result = Container(
        height: textContainerVH != null
            ? textContainerVH! * viewportSize.height
            : null,
        width: textContainerVW != null
            ? textContainerVW! * viewportSize.width
            : null,
        alignment: containerAlignment,
        padding: paddingStyling?.toEdgeInsets(viewportSize),
        margin: marginStyling?.toEdgeInsets(viewportSize),
        child: result,
      );

    return result;
  }

  /// Create an [ElevatedButton] with styled text as a child
  /// [text] - Text to show
  /// [viewportSize] - screen size
  /// [onTap] - method to call when button is tapped
  /// [size] - size of the button (in pixels)
  Widget elevatedButton(
    String text,
    Size viewportSize, {
    void Function()? onTap,
    BorderRadius? borderRadius,
    Size? size,
  }) {
    Widget result = ElevatedButton(
      onPressed: onTap ?? () {},
      child: container(text, viewportSize),
      style: borderRadius != null
          ? ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: borderRadius))
          : null,
    );

    if (size != null)
      result = result.constrained(
        width: size.width,
        height: size.height,
      );

    return result;
  }

  /// Create a [TextButton] with styled text
  /// [text] - text to show
  /// [viewportSize] - size of the screen
  /// [onTap] - method to call when the button is tapped on
  /// [buttonStyle] - style of the button to use if change from global one is
  /// needed
  /// [containerStyling] - styling of the container around the button if needed
  /// to have one
  Widget textButton(
    String text,
    Size viewportSize, {
    void Function()? onTap,
    ButtonStyle? buttonStyle,
    ContainerImageStyling? containerStyling,
  }) {
    Widget result = TextButton(
      child: container(text, viewportSize),
      onPressed: onTap ?? () {},
      style: buttonStyle,
    );

    if (containerStyling != null) {
      result = containerStyling.toWidget(
        viewportSize,
        child: result,
      );
    }

    return result;
  }

  /// Create a [TappableText] from this styling
  /// [onTap] - method to call when text is tapped
  /// [text] - text to show
  /// [onHover] - what to do when text is hovered over
  /// [hoverUnderline] - show the underline when text is hovered over or not
  TappableText tappable({
    required void Function() onTap,
    required String text,
    void Function(bool)? onHover,
    bool hoverUnderline = true,
    bool alwaysUnderline = false,
    Color? hoverColor,
    Color? focusColor,
    Color? splashColor,
    Color? highlightColor,
  }) =>
      TappableText(
        onTap: onTap,
        childTextStyling: this,
        text: text,
        onHover: onHover,
        hoverUnderline: hoverUnderline,
        alwaysUnderline: alwaysUnderline,
        focusColor: focusColor,
        highlightColor: highlightColor,
        hoverColor: hoverColor,
        splashColor: splashColor,
      );

  /// Create a copy of this styling with overridden members by respective
  /// function parameters
  TextStyling copyWith({
    Color? newTextColor,
    TextDecoration? newDecoration,
    bool? newAutoSize,
    EdgeInsetsStyling? newMarginStyling,
    double? newTextContainerVW,
    double? newTextContainerVH,
    double? newFontSizeVH,
    String? newFontFamily,
    TextOverflow? newOverflow,
    FontWeight? newFontWeight,
    Alignment? newContainerAlignment,
    TextAlign? newTextAlignment,
    EdgeInsetsStyling? newPaddingStyling,
    FontStyle? newFontStyle,
    int? newMaxLines,
  }) =>
      TextStyling(
        textContainerVH: newTextContainerVH ?? textContainerVH,
        textContainerVW: newTextContainerVW ?? textContainerVW,
        fontSizeVH: newFontSizeVH ?? fontSizeVH,
        fontFamily: newFontFamily ?? fontFamily,
        overflow: newOverflow ?? overflow,
        fontWeight: newFontWeight ?? fontWeight,
        containerAlignment: newContainerAlignment ?? containerAlignment,
        textAlignment: newTextAlignment ?? textAlignment,
        textColor: newTextColor ?? textColor,
        decoration: newDecoration ?? decoration,
        marginStyling: newMarginStyling ?? marginStyling,
        paddingStyling: newPaddingStyling ?? paddingStyling,
        maxLines: newMaxLines ?? maxLines,
        autoSize: newAutoSize ?? autoSize,
        fontStyle: newFontStyle ?? fontStyle,
      );
}

/// Class for stying a [TextField]
class TextFieldStyling {
  /// Default transparent border
  static final UnderlineInputBorder defaultUnderlineInputBorder =
      UnderlineInputBorder(
    borderSide: new BorderSide(
      color: Colors.transparent,
      style: BorderStyle.none,
    ),
    borderRadius: BorderRadius.circular(80),
  );

  UnderlineInputBorder? border;
  UnderlineInputBorder? enabledBorder;
  UnderlineInputBorder? disabledBorder;
  UnderlineInputBorder? errorBorder;
  UnderlineInputBorder? focusedBorder;
  UnderlineInputBorder? focusedErrorBorder;

  final TextStyling textStyling;
  final TextStyling hintTextStyling;
  final TextAlignVertical textAlignVertical;

  Color? fillColor;
  final bool filled;
  final EdgeInsetsStyling paddingStyling;

  final double? widthVW;
  final double? heightVH;

  final EdgeInsetsStyling? marginStyling;

  final int maxLines;
  final bool obscureText;

  final TextInputType? keyboardType;

  final TextEditingController? controller;

  final void Function(String)? onChanged;

  TextFieldStyling({
    this.border,
    this.enabledBorder,
    this.disabledBorder,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    required this.textStyling,
    required this.hintTextStyling,
    this.textAlignVertical = TextAlignVertical.center,
    this.fillColor,
    this.filled = true,
    this.paddingStyling = const EdgeInsetsStyling.zero(),
    this.widthVW,
    this.heightVH,
    this.marginStyling,
    this.controller,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
  }) {
    border = border ?? defaultUnderlineInputBorder;
    enabledBorder = enabledBorder ?? (border ?? defaultUnderlineInputBorder);
    disabledBorder = disabledBorder ?? (border ?? defaultUnderlineInputBorder);
    errorBorder = errorBorder ?? (border ?? defaultUnderlineInputBorder);
    focusedBorder = focusedBorder ?? (border ?? defaultUnderlineInputBorder);
    focusedErrorBorder =
        focusedErrorBorder ?? (border ?? defaultUnderlineInputBorder);

    if (fillColor == null) fillColor = HexColor('#F0F0F0');
  }

  /// Create a [TextField] widget from this styling
  /// [hintText] - text to show in the field by default
  /// [viewportSize] - size of the screen
  Widget toWidget(String hintText, Size viewportSize) {
    double height = viewportSize.height;
    double width = viewportSize.width;

    Widget textField = TextField(
      maxLines: maxLines,
      obscureText: obscureText,
      textAlignVertical: textAlignVertical,
      style: textStyling.toTextStyle(height),
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: filled,
        contentPadding: paddingStyling.toEdgeInsets(viewportSize),
        border: border,
        enabledBorder: enabledBorder,
        disabledBorder: disabledBorder,
        errorBorder: errorBorder,
        focusedBorder: focusedBorder,
        focusedErrorBorder: focusedErrorBorder,
        hintText: hintText,
        hintStyle: hintTextStyling.toTextStyle(height),
      ),
      expands: false,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );

    if (heightVH != null || widthVW != null || marginStyling != null) {
      textField = Container(
        width: widthVW != null ? widthVW! * width : null,
        height: heightVH != null ? heightVH! * height : null,
        margin: marginStyling?.toEdgeInsets(viewportSize),
        child: textField,
      );
    }

    return textField;
  }

  /// Create a copy of this styling with overridden members by respective
  /// function parameters
  TextFieldStyling copyWith({
    UnderlineInputBorder? newBorder,
    UnderlineInputBorder? newEnabledBorder,
    UnderlineInputBorder? newDisabledBorder,
    UnderlineInputBorder? newErrorBorder,
    UnderlineInputBorder? newFocusedBorder,
    UnderlineInputBorder? newFocusedErrorBorder,
    TextStyling? newTextStyling,
    TextStyling? newHintTextStyling,
    TextAlignVertical? newTextAlignVertical,
    Color? newFillColor,
    bool? newFilled,
    EdgeInsetsStyling? newPaddingStyling,
    double? newWidthVW,
    double? newHeightVH,
    EdgeInsetsStyling? newMarginStyling,
    TextEditingController? newController,
    int? newMaxLines,
    bool? newObscureText,
    TextInputType? newKeyboardType,
    void Function(String)? newOnChanged,
  }) =>
      TextFieldStyling(
        textStyling: newTextStyling ?? textStyling,
        hintTextStyling: newHintTextStyling ?? hintTextStyling,
        filled: newFilled ?? filled,
        fillColor: newFillColor ?? fillColor,
        paddingStyling: newPaddingStyling ?? paddingStyling,
        widthVW: newWidthVW ?? widthVW,
        heightVH: newHeightVH ?? heightVH,
        marginStyling: newMarginStyling ?? marginStyling,
        border: newBorder ?? border,
        focusedBorder: newFocusedBorder ?? focusedBorder,
        errorBorder: newErrorBorder ?? errorBorder,
        disabledBorder: newDisabledBorder ?? disabledBorder,
        enabledBorder: newEnabledBorder ?? enabledBorder,
        controller: newController ?? controller,
        focusedErrorBorder: newFocusedErrorBorder ?? focusedErrorBorder,
        textAlignVertical: newTextAlignVertical ?? textAlignVertical,
        maxLines: newMaxLines ?? maxLines,
        obscureText: newObscureText ?? obscureText,
        keyboardType: newKeyboardType ?? keyboardType,
        onChanged: newOnChanged ?? onChanged,
      );
}
