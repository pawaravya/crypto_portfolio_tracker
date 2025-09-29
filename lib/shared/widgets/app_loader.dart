import 'dart:ui';

import 'package:crypto_portfolio_tracker/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppLoader {
  static Widget loaderWidget({Color? color}) {
    final finalColor = color ?? HexColor(ColorConstants.themeColor);
    return Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(strokeWidth: 2, color: finalColor),
      ),
    );
  }
}
