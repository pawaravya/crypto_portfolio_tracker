import 'package:crypto_portfolio_tracker/core/constants/color_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/image_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomInputText extends StatefulWidget {
  String labelText;
  String hintText;
  bool? isSuffixIcon;
  bool? isPrefixIcon;
  final TextEditingController? textEditingController;
  bool? isSecure;

  bool isFlag;

  TextInputType keyboardType;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  String errorText;
  String? prefixIconPath;
  int? maxLength = 50;
  bool? enable;
  bool isBgTransperant;
  final Function(String changedText)? onChanged;
  double? cornerRadius;
  double? height = 48;
  List<TextInputFormatter>? inputFormatters;
  bool readOnly;
  String? disableTextFieldColor;
  String? disableTextColor;
  bool isMandatory;
  bool isErrorBorder;
  Function()? onSuffixIconTap;
  Function(String)? onSubmitted;
  bool isFirstLetterCapital;
  bool isForSearch;
  EdgeInsets? contentPadding;
  String suffixIconPath;

  CustomInputText({
    super.key,
    required this.labelText,
    required this.hintText,
    this.isSuffixIcon,
    this.keyboardType = TextInputType.text,
    this.textEditingController,
    this.isSecure,
    this.onEditingComplete,
    this.textInputAction,
    this.focusNode,
    this.errorText = "",
    this.isPrefixIcon,
    this.prefixIconPath = "",
    this.isFlag = false,
    this.maxLength,
    this.enable = true,
    this.onChanged,
    this.isBgTransperant = false,
    this.cornerRadius = 100,
    this.inputFormatters,
    this.readOnly = false,
    this.height = 50,
    this.disableTextFieldColor,
    this.isMandatory = false,
    this.isErrorBorder = false,
    this.onSuffixIconTap,
    this.onSubmitted,
    this.isFirstLetterCapital = false,
    this.isForSearch = false,
    this.contentPadding,
    this.suffixIconPath = "",
    this.disableTextColor,
  });

  @override
  State<CustomInputText> createState() => _GetTextFieldState();
}

class _GetTextFieldState extends State<CustomInputText> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != "")
          RichText(
            text: TextSpan(
              text: widget.labelText,
              style: TextStyle(
                fontFamily: StringConstants.poppinsFontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: HexColor(ColorConstants.greyShade1),
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: HexColor(
              widget.isForSearch
                  ? ColorConstants.searchInputColor
                  : ColorConstants.whiteColor,
            ),
            borderRadius: BorderRadius.circular(widget.cornerRadius!),
          ),
          height: widget.height,
          child: TextField(
            autofocus: false,
            style: TextStyle(
              fontFamily: StringConstants.poppinsFontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: HexColor(ColorConstants.blackShade1),
            ),
            textCapitalization:
                widget.keyboardType == TextInputType.emailAddress
                ? TextCapitalization.none
                : TextCapitalization.sentences,
            inputFormatters: widget.inputFormatters ?? [],
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            onSubmitted: (val) {
              if (widget.onSubmitted != null) {
                widget.onSubmitted!(val);
              }
            },

            onEditingComplete: widget.onEditingComplete,
            maxLength: widget.maxLength,
            focusNode: widget.focusNode,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            controller: widget.textEditingController,
            cursorColor: Colors.black,
            obscureText: widget.isSecure ?? false,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontFamily: StringConstants.poppinsFontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 13,
                letterSpacing: 0,
                color: HexColor(ColorConstants.greyShade1),
              ),
              counterText: "",
              suffixIcon: widget.prefixIconPath != null
                  ? widget.suffixIconPath != ""
                        ? IconButton(
                            onPressed: () {
                              if (widget.onSuffixIconTap != null) {
                                widget.onSuffixIconTap!();
                              }
                            },
                            icon: SvgPicture.asset(widget.suffixIconPath),
                          )
                        : widget.isSecure != null
                        ? IconButton(
                            iconSize: 16,
                            icon: widget.isSecure!
                                ? SvgPicture.asset(
                                    ImageConstants.eyeOffImage,
                                    color: widget.isErrorBorder
                                        ? Colors.red
                                        : Colors.black,
                                  )
                                : SvgPicture.asset(
                                    ImageConstants.eyeImage,
                                    color: widget.isErrorBorder
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                            onPressed: () {
                              if (widget.onSuffixIconTap != null) {
                                widget.onSuffixIconTap!();
                              }
                            },
                          )
                        : null
                  : null,
              prefixIcon: widget.prefixIconPath != null
                  ? widget.prefixIconPath != ""
                        ? IconButton(
                            onPressed: () {
                              if (widget.onSuffixIconTap != null) {
                                widget.onSuffixIconTap!();
                              }
                            },
                            icon: SvgPicture.asset(widget.prefixIconPath ?? ""),
                          )
                        : null
                  : null,
              border: getBorder(),
              focusedBorder: getBorder(),
              enabledBorder: getBorder(),
              errorBorder: getBorder(),
              contentPadding:
                  widget.contentPadding ??
                  const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            ),
          ),
        ),
        Visibility(
          visible: widget.errorText.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              widget.errorText,
              style: TextStyle(fontSize: 12, color: Colors.red),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
        ),
      ],
    );
  }

  InputBorder getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.cornerRadius!),
      borderSide: BorderSide(
        color: HexColor(ColorConstants.themeColor),
        width: 1,
      ),
    );
  }
}
