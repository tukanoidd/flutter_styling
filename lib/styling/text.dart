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
          .With(
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
  final String fontFamily;
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

  TextStyling({
    this.textContainerVH,
    this.textContainerVW,
    this.fontFamily = 'Sen',
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
  });

  /// Turn styling data into Google font
  ///
  /// [viewportHeight] - Screen Height
  TextStyle fontStyle(double viewportHeight) => GoogleFonts.getFont(
        fontFamily,
        fontSize: fontSizeVH * viewportHeight,
        fontWeight: fontWeight,
        color: textColor,
        decoration: decoration,
      );

  /// Create container around the Text widget
  ///
  /// [text] - text of the widget
  /// [viewportHeight] - Screen Height
  Widget container(String text, Size viewportSize) {
    Widget result = autoSize
        ? AutoSizeText(
            text,
            style: fontStyle(viewportSize.height),
            textAlign: textAlignment,
            overflow: TextOverflow.visible,
            maxLines: maxLines,
          )
        : Text(
            text,
            style: fontStyle(viewportSize.height),
            textAlign: textAlignment,
            overflow: TextOverflow.visible,
            maxLines: maxLines,
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

  TextStyling With({
    Color? newTextColor,
    TextDecoration? newDecoration,
    bool? newAutoSize,
    EdgeInsetsStyling? newMarginStyling,
    double? newTextContainerVW,
  }) =>
      TextStyling(
        textContainerVH: textContainerVH,
        textContainerVW: newTextContainerVW ?? textContainerVW,
        fontSizeVH: fontSizeVH,
        fontFamily: fontFamily,
        overflow: overflow,
        fontWeight: fontWeight,
        containerAlignment: containerAlignment,
        textAlignment: textAlignment,
        textColor: newTextColor ?? textColor,
        decoration: newDecoration ?? decoration,
        marginStyling: newMarginStyling ?? marginStyling,
        paddingStyling: paddingStyling,
        maxLines: maxLines,
        autoSize: newAutoSize ?? autoSize,
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
      style: textStyling.fontStyle(height),
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
        hintStyle: hintTextStyling.fontStyle(height),
      ),
      expands: false,
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
