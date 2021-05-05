part of '../tukanoid_styling.dart';

class TappableText extends StatefulWidget {
  final void Function() onTap;
  final void Function(bool)? onHover;
  final bool hoverUnderline;
  final TextStyling childTextStyling;
  final String text;

  const TappableText({
    Key? key,
    required this.onTap,
    this.onHover,
    this.hoverUnderline = true,
    required this.childTextStyling,
    required this.text,
  }) : super(key: key);

  @override
  _TappableTextState createState() => _TappableTextState();
}

class _TappableTextState extends State<TappableText> {
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
      child: widget.childTextStyling
          .copyWith(
            newDecoration:
                _isHovering ? TextDecoration.underline : TextDecoration.none,
          )
          .container(
            widget.text,
            viewportSize,
          ),
    );
  }
}

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
  ///
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
  ///
  /// [text] - text of the widget
  /// [viewportHeight] - Screen Height
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

  Widget textButton(
    String text,
    Size viewportSize, {
    void Function()? onTap,
    ButtonStyle? buttonStyle,
    Size? sizeVS,
    EdgeInsetsStyling? marginStyling,
  }) {
    Widget result = TextButton(
      child: container(text, viewportSize),
      onPressed: onTap ?? () {},
      style: buttonStyle,
    );

    if (sizeVS != null || marginStyling != null) {
      final Size? size = sizeVS?.mult(viewportSize);

      result = Container(
        child: result,
        width: size?.width == 0 ? null : size?.width,
        height: size?.height == 0 ? null : size?.height,
        margin: marginStyling?.toEdgeInsets(viewportSize),
      );
    }

    return result;
  }

  TappableText tappable({
    required void Function() onTap,
    required String text,
    void Function(bool)? onHover,
    bool hoverUnderline = true,
  }) =>
      TappableText(
        onTap: onTap,
        childTextStyling: this,
        text: text,
        onHover: onHover,
        hoverUnderline: hoverUnderline,
      );

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

class TextFieldStyling {
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

  final TextEditingController? controller;

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
  }) {
    border = border ?? defaultUnderlineInputBorder;
    enabledBorder = enabledBorder ?? defaultUnderlineInputBorder;
    disabledBorder = disabledBorder ?? defaultUnderlineInputBorder;
    errorBorder = errorBorder ?? defaultUnderlineInputBorder;
    focusedBorder = focusedBorder ?? defaultUnderlineInputBorder;
    focusedErrorBorder = focusedErrorBorder ?? defaultUnderlineInputBorder;

    if (fillColor == null) fillColor = HexColor('#F0F0F0');
  }

  Widget toWidget(String hintText, Size viewportSize) {
    double height = viewportSize.height;
    double width = viewportSize.width;

    Widget textField = TextField(
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
}
