// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:deal_or_not_deal/utills/res.dart';
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
  List priceListSecondaryOne = [
    {
      "image": "images/Rose - 1.png",
      "priceId": "1",
      "priceValue": "1",
      "priceName": "Rose",
    },
    {
      "image": "images/Finger Heart - 5.png",
      "priceId": "2",
      "priceValue": "5",
      "priceName": "Finger Heart",
    },
    {
      "image": "images/Tiny Diny - 10.png",
      "priceId": "3",
      "priceValue": "10",
      "priceName": "Tiny Diny",
    },
    {
      "image": "images/Doughnut - 30.png",
      "priceId": "4",
      "priceValue": "30",
      "priceName": "Doughnut",
    },
    {
      "image": "images/Hand Heart - 100.png",
      "priceId": "5",
      "priceValue": "100",
      "priceName": "Hand Heart",
    },
    {
      "image": "images/Sunglasses - 199.png",
      "priceId": "6",
      "priceValue": "199",
      "priceName": "Sunglasses",
    },
    {
      "image": "images/Corgi - 299.png",
      "priceId": "7",
      "priceValue": "299",
      "priceName": "Corgi",
    },
    {
      "image": "images/Money Gun - 500.png",
      "priceId": "8",
      "priceValue": "500",
      "priceName": "Money Gun",
    },
    {
      "image": "images/Swan - 699.png",
      "priceId": "9",
      "priceValue": "699",
      "priceName": "Swan",
    },
    {
      "image": "images/Galaxy - 1,000.png",
      "priceId": "10",
      "priceValue": "1000",
      "priceName": "Galaxy",
    },
    {
      "image": "images/Chasing The Dream - 1,500.png",
      "priceId": "11",
      "priceValue": "1500",
      "priceName": "Chasing The Dream",
    },
    {
      "image": "images/Whale Diving - 2,150.png",
      "priceId": "12",
      "priceValue": "2150",
      "priceName": "Whale Diving",
    },
    {
      "image": "images/Motorcycle - 2,988.png",
      "priceId": "13",
      "priceValue": "2988",
      "priceName": "MotorCycle",
    },
  ];
  List priceListSecondaryTwo = [
    {
      "image": "images/Golden Party - 3,000.png",
      "priceId": "14",
      "priceValue": "3000",
      "priceName": "Golden Party",
    },
    {
      "image": "images/Flower Overflow - 4,000.png",
      "priceId": "15",
      "priceValue": "4000",
      "priceName": "Flower Overflow",
    },
    {
      "image": "images/Leon The Kitten - 4,888.png",
      "priceId": "16",
      "priceValue": "4888",
      "priceName": "Leon The Kitten",
    },
    {
      "image": "images/Flying Jets - 5,000.png",
      "priceId": "17",
      "priceValue": "5000",
      "priceName": "Flying Jets",
    },
    {
      "image": "images/Wolf - 5,500.png",
      "priceId": "18",
      "priceValue": "5500",
      "priceName": "Wolf",
    },
    {
      "image": "images/Lili The Leopard - 6,599.png",
      "priceId": "19",
      "priceValue": "6599",
      "priceName": "Lili The Leopard",
    },
    {
      "image": "images/Sports Car - 7,000.png",
      "priceId": "20",
      "priceValue": "7000",
      "priceName": "Sports Car",
    },
    {
      "image": "images/Interstellar - 10,000.png",
      "priceId": "21",
      "priceValue": "10000",
      "priceName": "Interstellar",
    },
    {
      "image": "images/Rosa Nebula - 15,000.png",
      "priceId": "22",
      "priceValue": "15000",
      "priceName": "Rosa Nebula",
    },
    {
      "image": "images/TikTok Shuttle - 20,000.png",
      "priceId": "23",
      "priceValue": "20000",
      "priceName": "TikTok Shuttle",
    },
    {
      "image": "images/Rose Carriage - 25,000.png",
      "priceId": "24",
      "priceValue": "25999",
      "priceName": "Adams Dream",
    },
    {
      "image": "images/Lion - 29,999.png",
      "priceId": "25",
      "priceValue": "29999",
      "priceName": "Lion",
    },
    {
      "image": "images/TikTok Universe - 44,999.png",
      "priceId": "26",
      "priceValue": "44999",
      "priceName": "TikTok Universe",
    },
  ];
  List selectedListTwo = [];
  List selectedListOne = [];
  void checktheLists() {
    try {
      setState(() {
        selectedListOne = priceListOne.any((item) => item['image'] == "")
            ? priceListSecondaryOne
            : priceListOne;
        selectedListTwo = priceListTwo.any((item) => item['image'] == "")
            ? priceListSecondaryTwo
            : priceListTwo;
        debugPrint("this is secondery list one:$selectedListOne");
        debugPrint("this is secondery list two:$selectedListTwo");
      });
    } catch (e) {
      debugPrint("this is the setstaeerror:$e");
    }
  }

  @override
  void initState() {
    checktheLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which lists to use

    // Initialize the PriceController
    PriceController priceController = Get.put(
      PriceController(
        priceListOneDynamic: selectedListOne.obs,
        priceListTwoDynamic: selectedListTwo.obs,
        targetCase: widget.selectedUserData['caseImage'],
      ),
    );

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
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio: 2.2,
                                  ),
                                  itemCount: priceController.caseDynamic.length,
                                  itemBuilder: (context, index) {
                                    String caseImage =
                                        priceController.caseDynamic[index];

                                    return GestureDetector(
                                      onTap: () =>
                                          priceController.onCaseTapped(index),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, right: 16),
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
                                                ? Image.asset(
                                                    caseImage,
                                                    fit: BoxFit.contain,
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
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
