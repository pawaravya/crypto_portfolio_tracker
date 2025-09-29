import 'dart:ui';

import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_text.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

class CommonEmptyState extends StatefulWidget {
  final String stateScreenHeading;
  final String stateScreenSubHeading;
  final String stateScreenEmoji;
  final Function() onTapButton;
  final Function(BuildContext context)? onTapBackButton;
  final String buttonText;
  final bool isButtonRequired;
  bool isBackButtonRequired;

  CommonEmptyState({
    Key? key,
    required this.stateScreenHeading,
    required this.stateScreenEmoji,
    required this.onTapButton,
    this.stateScreenSubHeading = "",
    this.onTapBackButton,
    this.buttonText = StringConstants.yesText,
    this.isButtonRequired = true,
    this.isBackButtonRequired = false,
  }) : super(key: key);

  @override
  State<CommonEmptyState> createState() => _CommonEmptyStateState();
}

class _CommonEmptyStateState extends State<CommonEmptyState> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.onTapBackButton != null) {
          widget.onTapBackButton!(context);
        } else {
          widget.onTapButton();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.stateScreenEmoji != "",
                      child: Lottie.asset(
                        height: 200,
                        width: 200,
                        widget.stateScreenEmoji,
                        repeat: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    AppText(
                      widget.stateScreenHeading,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 7),
                    AppText(
                      widget.stateScreenSubHeading,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 50),
                    Visibility(
                      visible: widget.isButtonRequired,
                      child: CustomButton(
                        onPressed: () {
                          widget.onTapButton();
                        },
                        text: widget.buttonText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
