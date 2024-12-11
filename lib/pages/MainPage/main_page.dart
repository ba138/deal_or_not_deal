// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:deal_or_not_deal/Controllers/price_controller.dart';
import 'package:deal_or_not_deal/utills/colors.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> selectedUserData;
  const MainPage({
    super.key,
    required this.selectedUserData,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PriceController priceController = Get.put(PriceController());

  @override
  void initState() {
    priceController.getData(widget.selectedUserData["caseImage"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Card(
              child: Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: priceController.priceListOneDynamic.length,
                      itemBuilder: (context, index) {
                        final item = priceController.priceListOneDynamic[index];
                        return item['image'] == ""
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7.0,
                                    horizontal: 8), // Add spacing here
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Image.asset(
                                      //   item['image'],
                                      //   width: 30,
                                      //   height: 30,
                                      //   fit: BoxFit.cover,
                                      // ),
                                      Text(
                                        "${item['priceValue']}",
                                        style: const TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7.0,
                                  horizontal: 8, // Add spacing here
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primaryColor,
                                        AppColors.secondPrimaryColor
                                      ],
                                      begin: Alignment
                                          .centerLeft, // Gradient starts from left
                                      end: Alignment
                                          .centerRight, // Gradient ends at right
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        item['image'],
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        "${item['priceValue']}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    );
                  })),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          height: 120,
                          width: 600,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: AssetImage("images/logo.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(
                          () => SizedBox(
                            child: Image.asset(
                              priceController.userCaseImage.value,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.75,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemCount: priceController.caseDynamic.length,
                                  itemBuilder: (context, index) {
                                    String caseImage =
                                        priceController.caseDynamic[index];

                                    return GestureDetector(
                                      onTap: () =>
                                          priceController.onCaseTapped(index),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 4,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors
                                                  .white, // Highlight tapped case
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: caseImage.isNotEmpty
                                              ? Image.asset(caseImage,
                                                  fit: BoxFit.contain)
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                            Obx(
                              () => priceController.showbuttons.value != true
                                  ? Image.asset(
                                      priceController.roundImages[
                                          priceController.round.value - 1],
                                      height: 70,
                                      width: MediaQuery.sizeOf(context).width,
                                      fit: BoxFit.contain,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (priceController.isSwap.value ==
                                                false) {
                                              priceController.swapElements(
                                                  widget.selectedUserData[
                                                      'caseImage']);
                                            } else {
                                              Get.snackbar(
                                                  "Swap", "Already Swap");
                                            }
                                          },
                                          child: Container(
                                            height: 56,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              gradient: priceController
                                                          .isSwap.value ==
                                                      false
                                                  ? const LinearGradient(
                                                      colors: [
                                                        AppColors.primaryColor,
                                                        AppColors
                                                            .secondPrimaryColor
                                                      ],
                                                      begin: Alignment
                                                          .centerLeft, // Start from the left
                                                      end: Alignment
                                                          .centerRight, // End at the right
                                                    )
                                                  : const LinearGradient(
                                                      colors: [
                                                        AppColors.primaryColor,
                                                        AppColors.primaryColor
                                                      ],
                                                      begin: Alignment
                                                          .centerLeft, // Start from the left
                                                      end: Alignment
                                                          .centerRight, // End at the right
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Swap",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            priceController.revealPlayerCase();
                                          },
                                          child: Container(
                                            height: 56,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  AppColors.primaryColor,
                                                  AppColors.secondPrimaryColor
                                                ],
                                                begin: Alignment
                                                    .centerLeft, // Start from the left
                                                end: Alignment
                                                    .centerRight, // End at the right
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                "Reveal",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Card(
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                child: Obx(() {
                  return ListView.builder(
                    itemCount: priceController.priceListTwoDynamic.length,
                    itemBuilder: (context, index) {
                      final item = priceController.priceListTwoDynamic[index];
                      return item['image'] == ""
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7.0,
                                  horizontal: 8), // Add spacing here
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Image.asset(
                                    //   item['image'],
                                    //   width: 30,
                                    //   height: 30,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    Text(
                                      "${item['priceValue']}",
                                      style: const TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7.0,
                                  horizontal: 8), // Add spacing here
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                height: 40,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primaryColor,
                                        AppColors.secondPrimaryColor
                                      ],
                                      begin: Alignment
                                          .centerLeft, // Gradient starts from left
                                      end: Alignment
                                          .centerRight, // Gradient ends at right
                                    ),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      item['image'],
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "${item['priceValue']}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
