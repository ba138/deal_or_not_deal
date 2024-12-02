import 'dart:math';
import 'package:deal_or_not_deal/Controllers/price_controller.dart';
import 'package:deal_or_not_deal/pages/MainPage/widgets/price_list.dart';
import 'package:deal_or_not_deal/utills/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> cases =
      List.generate(26, (index) => "images/Case ${index + 1}.png");

  @override
  void initState() {
    super.initState();
    shuffleCases(); // Shuffle the cases when the widget initializes
  }

  void shuffleCases() {
    setState(() {
      cases.shuffle(Random());
    });
  }

  Widget buildRow(List<String> items, VoidCallback ontap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items
          .map(
            (image) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: ontap,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

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
                child: buildPriceList(priceListOne),
              ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildRow(cases.sublist(0, 7), () {
                              priceController.playMusic("images/boxopen.mp3");
                            }), // First row (7 items)
                            buildRow(cases.sublist(7, 13), () {
                              priceController.playMusic("images/boxopen.mp3");
                            }), // Second row (6 items)
                            buildRow(cases.sublist(13, 19), () {
                              priceController.playMusic("images/boxopen.mp3");
                            }), // Third row (6 items)
                            buildRow(cases.sublist(19, 26), () {
                              priceController.playMusic("images/boxopen.mp3");
                            }), // Fourth row (7 items)
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
                child: buildPriceList(priceListTwo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
