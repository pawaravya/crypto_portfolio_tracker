import 'dart:async';
import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class QuantityWidget extends StatefulWidget {
  int quantity;
  final Function(int) onQuantityChanged;
  int selectedQuamtityValue;
  double rightPadding;
  QuantityWidget({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.rightPadding = 30,
    required this.selectedQuamtityValue,
  });

  @override
  State<QuantityWidget> createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<QuantityWidget> {
  int selectedValue = 1;
  Timer? _debounce;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isCursorVisible = false;

  void updateQuantity(int newQuantity) {
    setState(() {
      selectedValue = newQuantity;
      _controller.text = newQuantity.toString();
    });

    widget.onQuantityChanged(selectedValue);
  }

  void _onQuantityChanged(String value) {
    var newQuantity = int.tryParse(value) ?? selectedValue;
    if (value == "") {
      newQuantity = 0;
    }
    if (newQuantity >= 1 && newQuantity <= widget.quantity) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      setState(() {
        selectedValue = newQuantity;
      });

      updateQuantity(selectedValue);
    } else if (newQuantity > widget.quantity) {
      _controller.text = widget.quantity.toString();
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      updateQuantity(widget.quantity);
      setState(() {
        selectedValue = widget.quantity;
      });
    } else if (newQuantity == 0) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(seconds: 1), () {
        updateQuantity(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = selectedValue.toString();
    return Row(
      children: [
        InkWell(
          onTap: selectedValue > 1
              ? () => updateQuantity(selectedValue - 1)
              : () {},
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 14.0, left: 0, bottom: 12),
              child: const Icon(Icons.remove, color: Colors.black, size: 18),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _focusNode.requestFocus();
          },
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 1,
              bottom: 12,
            ),
            height: 50,
            child: Center(
              child: IntrinsicWidth(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[1-9][0-9]*')),
                  ],
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: StringConstants.poppinsFontFamily,
                  ),
                  cursorColor: Colors.black,
                  enableInteractiveSelection: false,
                  cursorWidth: _isCursorVisible ? 2.0 : 0.0,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    _onQuantityChanged(value);
                  },
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: selectedValue < widget.quantity
              ? () => updateQuantity(selectedValue + 1)
              : () {},
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                top: 14.0,
                right: widget.rightPadding,
                bottom: 12,
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

