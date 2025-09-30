import 'package:crypto_portfolio_tracker/shared/widgets/app_text.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_view_utils.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto_portfolio_tracker/features/coins/view_models/coins_view_models.dart';
import 'package:crypto_portfolio_tracker/features/coins/views/coin_selection_card.dart';
import 'package:crypto_portfolio_tracker/features/coins/views/coin_card_shimmer.dart';
import 'package:crypto_portfolio_tracker/features/coins/model/coins_model.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/base_widget.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/common_empty_state.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/custom_input_text.dart';
import 'package:crypto_portfolio_tracker/core/constants/image_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CoinsController controller = Get.put(CoinsController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = "".obs;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      screen: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              SizedBox(width: 8),
              AppText("Coins ", fontSize: 22, fontWeight: FontWeight.w600),
            ],
          ),

          CustomInputText(
            labelText: "",
            hintText: "Search by name or symbol",
            suffixIconPath: ImageConstants.searchIcon,
            isForSearch: true,
            textEditingController: searchController,
            focusNode: _focusNode,
            onChanged: (value) => searchQuery.value = value.toLowerCase(),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: 10,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (_, __) => CoinCardShimmer(),
                );
              }

              if (controller.error.value != "") {
                return CommonEmptyState(
                  buttonText: "Retry",
                  isBackButtonRequired: false,
                  stateScreenHeading: "Oops!",
                  stateScreenSubHeading: controller.error.value!,
                  onTapButton: controller.fetchCoins,
                  stateScreenEmoji: "assets/error.json",
                );
              }

              final List<Coin> filteredCoins = controller.searchCoins(
                searchQuery.value,
              );

              if (filteredCoins.isEmpty) {
                return CommonEmptyState(
                  isButtonRequired: false,
                  stateScreenHeading: "No Coins Found",
                  stateScreenSubHeading: searchQuery.value.isEmpty
                      ? "No coins available."
                      : "No results match your search.",
                  onTapButton: () {},
                  stateScreenEmoji: ImageConstants.noCoinsFoundLottieIcon,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: filteredCoins.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final coin = filteredCoins[index];
                  return Obx(
                    () => CoinSelectionCard(
                      coin: coin,

                      isSelected: controller.selectedCoins.contains(coin),
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(height: 2),

          Obx(
            () => CustomButton(
              isDisabled: controller.selectedCoins.isEmpty,
              onPressed: () async {
                await controller.saveSelection();
                AppViewUtils.showTopSnackbar(
                  context,
                  "Coins has been added succesfully",
                );
                Navigator.of(context).pop(true);
              },
              text: "Save",
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
