import 'dart:ui';
import 'package:crypto_portfolio_tracker/core/constants/color_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/image_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_text.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppViewUtils {
    static bool _isSnackBarShowing = false;

  static getAssetImageSVG(
    String path, {
    double? height,
    double? width,
    Color? color,
  }) {
    return SvgPicture.asset(color: color, path, height: height, width: width);
  }

  static double getResponsiveHeight(
    BuildContext context,
    double? designHeight,
    double actualSizeAsPerDesign,
  ) {
    final double designSizee = designHeight ?? 844;
    return MediaQuery.of(context).size.height *
        (actualSizeAsPerDesign / designSizee);
  }

  static double getResponsiveWidth(
    BuildContext context,
    double? designwidth,
    double actualSizeAsPerDesign,
  ) {
    final double designSizee = designwidth ?? 390;
    return MediaQuery.of(context).size.width *
        (actualSizeAsPerDesign / designSizee);
  }

  static showBottomSheet(
    BuildContext context,
    Widget widgetToShow, {
    bool isDismissible = true,
    Function(dynamic)? onCloseBottomSheet,
    bool isPaddingRequire = true,
  }) {
    showModalBottomSheet(
      isDismissible: isDismissible,
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                ),
              ),
            ),

            // Main bottom sheet content
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(45),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: Container(
                    padding: isPaddingRequire
                        ? EdgeInsets.only(
                            left: 28,
                            right: 28,
                            top: 6,
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          )
                        : EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 6,
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),

                    child: Wrap(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Drag handle
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            widgetToShow,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (onCloseBottomSheet != null) {
        onCloseBottomSheet(value);
      }
    });
  }

  static void showLogoutConfirmation(
    BuildContext context,
    VoidCallback onLogOutAction,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          icon: Icon(Icons.logout_rounded, size: 40, color: Colors.red),
          title: AppText(
            StringConstants.logOutHeading,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: AppText(
                StringConstants.cancelText,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextButton(
              onPressed: () {
                //   Navigator.of(context).pop();
                onLogOutAction();
              },
              child: AppText(
                StringConstants.logOut,
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showAppExitConfirmation(
    BuildContext context,
    VoidCallback onAppExitTap,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: StringConstants.appExitHeading, // First part
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black, // Ensure color is set explicitly
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User cancels
                  },
                  child: AppText(
                    StringConstants.cancelText,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User confirms
                    onAppExitTap();
                  },
                  child: AppText(
                    StringConstants.exit,
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static showPopup(
    BuildContext context,
    String popUpHeading,
    Function() onTapbutton, {
    String popUpSubHeading = "",
    bool isRequiredSubheading = false,
    String buttonText = "",
    bool isbarrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: isbarrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            onTapbutton();
            return true;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: AppText(
                        popUpHeading,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: HexColor(ColorConstants.blackShade1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Visibility(
                      visible: isRequiredSubheading,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 9, bottom: 15),
                        child: AppText(
                          popUpSubHeading,
                          fontSize: 12,
                          color: HexColor(ColorConstants.greyShade1),
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onTapbutton();
                      },
                      text: buttonText,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      isSecondaryButton: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "Cancel",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showPopupWithYesButton(
    BuildContext context,
    String popUpHeading,
    Function(BuildContext context) onTapYesButton, {
    bool isLessPadding = false,
    String popUpSubHeading = "",
    Function(BuildContext context)? onTapNoButton,
    String buttonText = StringConstants.yesText,
  }) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Popup",
      barrierColor: Colors.transparent, // Transparent for blur effect
      transitionDuration: Duration(milliseconds: 200), // Smooth fade animation
      pageBuilder: (context, anim1, anim2) {
        return GestureDetector(
          onTap: () => Navigator.pop(context), // Close on background tap
          child: Scaffold(
            backgroundColor:
                Colors.transparent, // Ensures full-screen modal effect
            body: Stack(
              children: [
                // Blurred Background
                GestureDetector(
                  onTap: () => Navigator.pop(context), // Tap outside to close
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 6,
                      sigmaY: 6,
                    ), // Adjust blur strength
                    child: Container(
                      color: Colors.black.withOpacity(0.05), // Dimmed effect
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),

                // Popup Dialog
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            HexColor(ColorConstants.whiteColor).withOpacity(1),
                            HexColor(
                              ColorConstants.whiteColor,
                            ).withOpacity(0.8),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.transparent, // Border color
                          width: 0.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.5,
                            ), //  Softer shadow
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: isLessPadding ? 22 : 63.0,
                          right: isLessPadding ? 22 : 63,
                          top: 35 - 12,
                          bottom: 25,
                        ),
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HexColor(ColorConstants.blackColor),
                          ),
                          borderRadius: BorderRadius.circular(
                            18,
                          ), // Rounded border
                        ),
                        child: Wrap(
                          children: [
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: popUpHeading != "",
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: AppText(
                                        popUpHeading,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: popUpSubHeading != "",
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: AppText(
                                        popUpSubHeading,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                        color: HexColor(
                                          ColorConstants.blackColor,
                                        ),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: popUpSubHeading == "" ? 30 : 18,
                                  ),
                                  CustomButton(
                                    isSecondaryButton: true,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                    height: 43,
                                    width: 95,
                                    onPressed: () {
                                      onTapYesButton(context);
                                    },
                                    text: buttonText,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                      bottom: 0,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (onTapNoButton != null) {
                                          onTapNoButton(context);
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: AppText(
                                        StringConstants.noText,
                                        fontWeight: FontWeight.w700,
                                        textAlign: TextAlign.center,
                                        fontSize: 12,
                                        color: HexColor(
                                          ColorConstants.blackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
static void showTopSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    showTopSnackBar(
      animationDuration: duration,
      Overlay.of(context),
      Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: isError ? Colors.red : HexColor(ColorConstants.themeColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: AppText(message, color: HexColor(ColorConstants.whiteColor)),
        ),
      ),
    );
  }
  static dimissKeyBoard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static capitalizeFirstLetter(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  static Widget buildShimmerContainer({
    required double height,
    required double width,
    double borderRadius = 4,
  }) {
    return Shimmer.fromColors(
      baseColor: HexColor("#999999"),
      highlightColor: Colors.grey[400]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
