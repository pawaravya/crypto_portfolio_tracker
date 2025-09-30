import 'dart:async';

import 'package:crypto_portfolio_tracker/core/constants/color_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/image_constants.dart';
import 'package:crypto_portfolio_tracker/core/constants/string_constants.dart';
import 'package:crypto_portfolio_tracker/features/coins/model/enum_sort_options.dart';
import 'package:crypto_portfolio_tracker/features/coins/view_models/coins_view_models.dart';
import 'package:crypto_portfolio_tracker/features/coins/views/coin_card_shimmer.dart';
import 'package:crypto_portfolio_tracker/features/coins/views/search_coins_screen.dart';
import 'package:crypto_portfolio_tracker/shared/app_logger.dart';
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
  SortOption? selectedSortOption;
  Timer? _priceUpdateTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCoins();
      _startPeriodicPriceUpdates();
    });
  }

  void _startPeriodicPriceUpdates() {
    _priceUpdateTimer?.cancel();

    _priceUpdateTimer = Timer.periodic(Duration(minutes: 10), (timer) async {
      if (coinsController.coinsInPortFolio.isNotEmpty) {
        try {
          await coinsController.fetchPrices();
        } catch (e) {
          AppLogger.showErrorLogs("Error fetching periodic prices: $e");
        }
      }
    });
  }

  Future<void> fetchCoins() async {
    await coinsController.fetchCoins();
    await coinsController.fetchPrices();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      handleOnWillPop: () async {
        // final isExit = AppViewUtils.showAppExitConfirmation(
        //   context,
        //   () => SystemNavigator.pop(),
        // );
        // _focusNode.unfocus();
        return true;
      },
      screen: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "Welcome, User",
                fontSize: 22,
                maxLines: 1,
                fontWeight: FontWeight.w600,
              ),
              Obx(() {
                return AppText(
                  "\$ ${coinsController.coinsInPortFolio.fold(0.0, (sum, coin) {
                    final coinValue = (coin.price ?? 0) * (coin.selectedQuantuty ?? 0);
                    return sum + coinValue;
                  }).toStringAsFixed(4)}",
                  fontSize: 20,
                  maxLines: 1,
                  fontWeight: FontWeight.w600,
                );
              }),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomInputText(
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
                  hintText: "Search coins by name or symbol ",
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.sort,
                  size: 35,
                  color: HexColor(ColorConstants.themeColor),
                ),
                onPressed: () {
                  _focusNode.unfocus();
                  HandleSortingFucntionality();
                },
              ),
            ],
          ),
          SizedBox(height: 8),
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
                      (p) =>
                          (p.name ?? "").toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ) ||
                          (p.symbol ?? "").toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ),
                    )
                    .toList();
                if (selectedSortOption != null) {
                  switch (selectedSortOption!) {
                    case SortOption.nameAsc:
                      filtered.sort(
                        (a, b) => (a.name ?? "").compareTo(b.name ?? ""),
                      );
                      break;
                    case SortOption.nameDesc:
                      filtered.sort(
                        (a, b) => (b.name ?? "").compareTo(a.name ?? ""),
                      );
                      break;
                    case SortOption.priceLowToHigh:
                      filtered.sort(
                        (a, b) => (a.price ?? 0).compareTo(b.price ?? 0),
                      );
                      break;
                    case SortOption.priceHighToLow:
                      filtered.sort(
                        (a, b) => (b.price ?? 0).compareTo(a.price ?? 0),
                      );
                      break;
                  }
                }
                if (filtered.isEmpty) {
                  return CommonEmptyState(
                    isButtonRequired: false,
                    stateScreenHeading: "No Coins Found in your portfolio",
                    stateScreenSubHeading: searchQuery.isEmpty
                        ? "Looks like there are no coins available right now."
                        : "We couldn’t find any coins matching your search.",
                    stateScreenEmoji: ImageConstants.noCoinsFoundLottieIcon,
                    onTapButton: () {},
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final coin = filtered[index];
                    return Dismissible(
                      key: ValueKey(coin.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await AppViewUtils.showPopup(
                          buttonText: "Yes",
                          isRequiredSubheading: true,
                          popUpSubHeading:
                              "Are you sure you want to remove ${coin.name}",

                          context,
                          "Remove Coin",
                          () {
                            coinsController.removeFromPortfolio(coin);
                            AppViewUtils.showTopSnackbar(
                              context,
                              "Coin has been successfully remove from your portfolil",
                            );
                          },
                        );
                      },

                      child: Container(
                        height: 160,
                        child: Card(
                          elevation: 3,
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: AppText(
                                              textAlign: TextAlign.start,
                                              coin.name ?? "No Title",
                                              maxLines: 1,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      AppText(
                                        textAlign: TextAlign.start,
                                        coin.symbol ?? "No Title",
                                        maxLines: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            "QTY: ${coin.selectedQuantuty}",
                                          ),
                                          const SizedBox(height: 8),
                                          Visibility(
                                            replacement:
                                                AppViewUtils.buildShimmerContainer(
                                                  height: 18,
                                                  width: 100,
                                                ),
                                            visible: !coinsController
                                                .isPrizesLoading
                                                .value,
                                            child: AppText(
                                              "\$ ${coin.price}",
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      AppText(
                                        textAlign: TextAlign.start,
                                        "Total Value: \$${(coin.price ?? 0) * (coin.selectedQuantuty ?? 0)}",
                                        maxLines: 1,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          SizedBox(height: 5),

          CustomButton(
            onPressed: () async {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SearchScreen();
                      },
                    ),
                  )
                  .then((value) {
                    _focusNode.unfocus();
                    if (value != null && value == true) {
                      coinsController.fetchPrices();
                    }
                  });
            },
            text: "Add ",
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void HandleSortingFucntionality() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const AppText("Name: A → Z", textAlign: TextAlign.start),
              onTap: () {
                setState(() => selectedSortOption = SortOption.nameAsc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const AppText("Name: Z → A", textAlign: TextAlign.start),
              onTap: () {
                setState(() => selectedSortOption = SortOption.nameDesc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const AppText(
                "Price: Low → High",
                textAlign: TextAlign.start,
              ),
              onTap: () {
                setState(() => selectedSortOption = SortOption.priceLowToHigh);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const AppText(
                "Price: High → Low",
                textAlign: TextAlign.start,
              ),
              onTap: () {
                setState(() => selectedSortOption = SortOption.priceHighToLow);
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 50),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    _focusNode.dispose();
    _searchTextEditingController.dispose();
    super.dispose();
  }
}
