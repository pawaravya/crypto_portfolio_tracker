import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_text.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/custom_button.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/network_image_with_placeholder.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CoinCard extends StatelessWidget {
  final Coin coin;

  const CoinCard({Key? key, required this.coin}) : super(key: key);

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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: NetworkImageWithPlaceholder(
                  imageUrl: "",
                  placeholderAsset: "",
                  width: 112,
                  height: 112,
                  boxfit: BoxFit.contain,
                ),
              ),
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
                            coin.name ?? "No Title",
                            maxLines: 2,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(
                          "\$ 00",
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),

                        SizedBox(
                          height: 34,
                          width: 135,
                          child: CustomButton(
                            radius: 50,
                            isSecondaryButton: true,
                            textStyle: TextStyle(fontSize: 13),
                            onPressed: () {},
                            text: "TODO",
                          ),
                        ),
                      ],
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
