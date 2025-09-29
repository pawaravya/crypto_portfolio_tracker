import 'package:crypto_portfolio_tracker/core/constants/color_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_loader.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed; // Make the callback nullable
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final String? icon;
  final double? radius;
  final TextStyle? textStyle;
  final bool isSecondaryButton;
  final bool isSolidRedColorButton;
  const CustomButton({
    super.key,
    required this.onPressed,
    this.width,
    this.height = 50,
    this.padding,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.radius = 12,
    this.textStyle,
    this.isSecondaryButton = false,
    this.isSolidRedColorButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (!isLoading && isDisabled == false) {
          if (onPressed != null) {
            onPressed!();
          }
        }
      },
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: HexColor(ColorConstants.themeColor),
          ),

          borderRadius: BorderRadius.circular(radius ?? 0),

          color: isSecondaryButton
              ? HexColor(ColorConstants.whiteColor)
              : isDisabled
              ? HexColor(ColorConstants.themeColor).withOpacity(0.5)
              : HexColor(ColorConstants.themeColor),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: !isLoading,
              replacement: AppLoader.loaderWidget(
                color: isSecondaryButton
                    ? HexColor(ColorConstants.themeColor)
                    : HexColor(ColorConstants.whiteColor),
              ),
              child: AppText(
                text,
                fontFamily: StringConstants.poppinsFontFamily,
                color: isSecondaryButton
                    ? HexColor(ColorConstants.themeColor)
                    : HexColor(ColorConstants.whiteColor),
                fontSize: textStyle?.fontSize ?? 16,
                fontWeight: textStyle?.fontWeight ?? FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
