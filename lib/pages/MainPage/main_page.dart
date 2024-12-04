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
  List<String> caseDynamic = [];
  List<String> priceImagesDynamic = [];

  List<bool> tappedCases = List.generate(26, (index) => false);
  int round = 1; // Track the current round
  int maxCasesPerRound = 6; // Number of cases to open per round
  List<int> selectedCases = []; // Cases opened in the current round
  List<int> revealedCases = []; // Cases revealed overall
  int bankerOffer = 0;

  // Images for each round
  List<String> roundImages = [
    "images/6 Cases To Open.png",
    "images/5 Cases To Open.png",
    "images/4 Cases To Open.png",
    "images/3 Cases To Open.png",
    "images/2 Cases To Open.png",
    "images/1 Case To Open.png"
  ];

  @override
  void initState() {
    super.initState();
    caseDynamic = cases;
    priceImagesDynamic = priceImages;

    shuffleCases();
  }

  void shuffleCases() {
    setState(() {
      caseDynamic.shuffle(Random());
      priceImagesDynamic.shuffle(Random());
    });
  }

  void onCaseTapped(int index, PriceController priceController) {
    if (selectedCases.length < maxCasesPerRound) {
      setState(() {
        selectedCases.add(index);
        tappedCases[index] = true;
        revealedCases.add(index);
      });
      priceController.playMusic("audio/boxopen.mp3");
    }

    if (selectedCases.length == maxCasesPerRound) {
      _showBankerOffer();
    }
  }

  void _showBankerOffer() {
    bankerOffer = Random().nextInt(10000) + 5000; // Example banker offer
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Banker’s Offer"),
          content:
              Text("The banker offers you \$${bankerOffer}. Do you accept?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _endGame();
              },
              child: Text("Deal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nextRound();
              },
              child: Text("No Deal"),
            ),
          ],
        );
      },
    );
  }

  void _nextRound() {
    setState(() {
      if (round < roundImages.length - 1) {
        maxCasesPerRound--;
      }
      round++;
      selectedCases.clear();
      tappedCases = List.generate(26, (index) => false);
    });
  }

  void _endGame() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Congratulations! You won \$${bankerOffer}."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  Widget buildGridView(List<String> items, PriceController priceController) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        String image = items[index];
        return GestureDetector(
          onTap: () => onCaseTapped(index, priceController),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: revealedCases.contains(index)
                  ? Image.asset(priceImagesDynamic[index], fit: BoxFit.contain)
                  : Image.asset(image, fit: BoxFit.contain),
            ),
          ),
        );
      },
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
                          children: [
                            Expanded(
                                child: buildGridView(
                                    caseDynamic, priceController)),
                            Image.asset(
                              roundImages[round -
                                  1], // Select image based on the round,
                              height: 70,
                              width: MediaQuery.sizeOf(context).width,
                              fit: BoxFit.contain,
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
                child: buildPriceList(priceListTwo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
