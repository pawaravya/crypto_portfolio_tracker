import 'package:crypto_portfolio_tracker/shared/widgets/app_view_utils.dart';
import 'package:flutter/material.dart';

class CoinCardShimmer extends StatelessWidget {
  const CoinCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              AppViewUtils.buildShimmerContainer(
                height: 112,
                width: 90,
                borderRadius: 8,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppViewUtils.buildShimmerContainer(
                      height: 20,
                      width: double.infinity,
                    ),
                    AppViewUtils.buildShimmerContainer(height: 18, width: 100),
                    AppViewUtils.buildShimmerContainer(height: 18, width: 60),
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
