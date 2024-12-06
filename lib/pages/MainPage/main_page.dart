import 'package:deal_or_not_deal/Controllers/price_controller.dart';
import 'package:deal_or_not_deal/pages/MainPage/widgets/price_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    PriceController priceController = Get.put(PriceController());
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
                                    horizontal: 8), // Add spacing here
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.amber.shade300,
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
                  })),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Card(
                    child: Container(
                      height: 120,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/logo.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
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
                                    bool isTapped =
                                        priceController.tappedCases[index];

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
                              () => Image.asset(
                                priceController.roundImages[
                                    priceController.round.value - 1],
                                height: 70,
                                width: MediaQuery.sizeOf(context).width,
                                fit: BoxFit.contain,
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
                                    color: Colors.amber.shade300,
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
