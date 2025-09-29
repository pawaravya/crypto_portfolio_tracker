// widgets/app_text.dart

import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextAlign? textAlign;
  final String? fontFamily;
  final FontWeight fontWeight;
  final double lineHeight;
  final TextDecoration? textDecoration;
  final TextOverflow? textOverflow;
  final double letterSpacing;
  final int maxLines;
  final FontStyle? fontStyle;

  const AppText(
    this.text, {
    super.key,
    this.color = Colors.black,
    this.fontSize = 16.0,
    this.textAlign = TextAlign.center,
    this.fontFamily = StringConstants.poppinsFontFamily,
    this.fontWeight = FontWeight.normal,
    this.lineHeight = 1.5,
    this.textDecoration,
    this.textOverflow = TextOverflow.ellipsis,
    this.letterSpacing = 0,
    this.maxLines = 20,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: true,
      ),
      textAlign: textAlign,
      textScaleFactor: 1.0,
      maxLines: maxLines > 0 ? maxLines : null,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        height: lineHeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        decoration: textDecoration,
        overflow: textOverflow,
      ),
    );
  }
}
