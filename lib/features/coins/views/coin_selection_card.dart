import 'package:crypto_portfolio_tracker/core/constants/color_constants.dart';
import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';
import 'package:crypto_portfolio_tracker/features/coins/view_models/coins_view_models.dart';
import 'package:crypto_portfolio_tracker/features/coins/views/quantity_widget.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_text.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/custom_button.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/network_image_with_placeholder.dart';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hexcolor/hexcolor.dart';

class CoinSelectionCard extends StatefulWidget {
  final Coin coin;
  bool? isSelected;

  CoinSelectionCard({Key? key, required this.coin, this.isSelected = false})
    : super(key: key);

  @override
  State<CoinSelectionCard> createState() => _CoidCardState();
}

class _CoidCardState extends State<CoinSelectionCard> {
  CoinsController coinsController = Get.put(CoinsController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Card(
        elevation: 3,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                activeColor: HexColor(ColorConstants.themeColor),

                value: widget.isSelected,
                onChanged: (value) {
                  coinsController.toggleSelection(widget.coin);
                },
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: NetworkImageWithPlaceholder(
              //     imageUrl: "",
              //     placeholderAsset: "",
              //     width: 112,
              //     height: 112,
              //     boxfit: BoxFit.contain,
              //   ),
              // ),
              const SizedBox(width: 12),

              // 🔹 Product Info
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppText(
                            textAlign: TextAlign.start,
                            widget.coin.name ?? "No Title",
                            maxLines: 1,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    AppText(
                      widget.coin.symbol ?? '',
                      color: Colors.black,
                      fontSize: 20,
                      maxLines: 1,
                      fontWeight: FontWeight.w400,
                    ),
                    Container(
                      color: Colors.white,
                      height: 40,
                      child: QuantityWidget(
                        quantity: 1000,
                        onQuantityChanged: (qty) {
                          widget.coin.selectedQuantuty = qty;
                          coinsController.addToSelection(widget.coin);
                        },
                        selectedQuamtityValue: widget.coin.selectedQuantuty!,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
