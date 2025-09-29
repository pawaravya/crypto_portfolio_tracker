import 'package:crypto_portfolio_tracker/core/constants/color_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/image_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:crypto_portfolio_tracker/features/coins/view_models/coins_view_models.dart';
import 'package:crypto_portfolio_tracker/features/coins/views/coid_card.dart';
import 'package:crypto_portfolio_tracker/features/coins/views/coin_card_shimmer.dart';
import 'package:crypto_portfolio_tracker/features/coins/views/search_coins_screen.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_text.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/app_view_utils.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/base_widget.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/common_empty_state.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/custom_button.dart';
import 'package:crypto_portfolio_tracker/shared/widgets/custom_input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:hexcolor/hexcolor.dart';

class UsersPortfolioScreen extends StatefulWidget {
  const UsersPortfolioScreen({super.key});

  @override
  State<UsersPortfolioScreen> createState() => _UsersPortfolioScreenState();
}

class _UsersPortfolioScreenState extends State<UsersPortfolioScreen> {
  String searchQuery = "";
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  CoinsController coinsController = Get.put(CoinsController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchCoins());
  }

  Future<void> fetchCoins() async {
    await coinsController.fetchCoins();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      handleOnWillPop: () async {
        final isExit = AppViewUtils.showAppExitConfirmation(
          context,
          () => SystemNavigator.pop(),
        );
        _focusNode.unfocus();
        return isExit;
      },
      screen: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText("Hii, User", fontSize: 24, fontWeight: FontWeight.w600),
              Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.filter,
                      color: HexColor(ColorConstants.themeColor),
                    ),
                    onPressed: () {
                      _focusNode.unfocus();
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          CustomInputText(
            suffixIconPath: ImageConstants.searchIcon,
            isSuffixIcon: true,
            textEditingController: _searchTextEditingController,
            focusNode: _focusNode,
            labelText: "",
            onChanged: (query) {
              setState(() => searchQuery = query.toLowerCase());
            },
            onSubmitted: (query) {
              setState(() => searchQuery = query.toLowerCase());
            },
            hintText: "Search coins...",
          ),
          SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              color: HexColor(ColorConstants.themeColor),
              onRefresh: fetchCoins,
              child: Obx(() {
                if (coinsController.isLoading.value) {
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: 10,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) => CoinCardShimmer(),
                  );
                }

                if (coinsController.error != "") {
                  return CommonEmptyState(
                    buttonText: "Retry",
                    isBackButtonRequired: false,
                    stateScreenSubHeading:
                        coinsController.error.value ?? "Unknown error",
                    stateScreenHeading:
                        StringConstants.somethingWentWrongMessage,
                    stateScreenEmoji: ImageConstants.somethingWentWrongLotie,
                    onTapButton: fetchCoins,
                  );
                }

                final filtered = coinsController.coinsInPortFolio
                    .where(
                      (p) => (p.name ?? "").toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return CommonEmptyState(
                    isButtonRequired: searchQuery.isEmpty ? true : false,
                    buttonText: "Add",
                    stateScreenHeading: "No Coins Found in your portfolio",
                    stateScreenSubHeading: searchQuery.isEmpty
                        ? "Looks like there are no coins available right now."
                        : "We couldn’t find any coins matching your search.",
                    stateScreenEmoji: ImageConstants.noProductsFoundLottieIcon,
                    onTapButton: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchScreen();
                          },
                        ),
                      );
                    },
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final coin = filtered[index];
                    return CoinCard(coin: coin);
                  },
                );
              }),
            ),
          ),
          CustomButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SearchScreen();
                  },
                ),
              );
            },
            text: "ADD ",
          ),
        ],
      ),
    );
  }
}
