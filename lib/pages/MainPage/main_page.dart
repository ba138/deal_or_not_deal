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
  List<String> priceImages = [
    "images/Rose - 1.png",
    "images/Finger Heart - 5.png",
    "images/Tiny Diny - 10.png",
    "images/Doughnut - 30.png",
    "images/Hand Heart - 100.png",
    "images/Sunglasses - 199.png",
    "images/Corgi - 299.png",
    "images/Money Gun - 500.png",
    "images/Swan - 699.png",
    "images/Galaxy - 1,000.png",
    "images/Chasing The Dream - 1,500.png",
    "images/Whale Diving - 2,150.png",
    "images/Motorcycle - 2,988.png",
    "images/Golden Party - 3,000.png",
    "images/Flower Overflow - 4,000.png",
    "images/Leon The Kitten - 4,888.png",
    "images/Flying Jets - 5,000.png",
    "images/Wolf - 5,500.png",
    "images/Lili The Leopard - 6,599.png",
    "images/Sports Car - 7,000.png",
    "images/Interstellar - 10,000.png",
    "images/Rosa Nebula - 15,000.png",
    "images/TikTok Shuttle - 20,000.png",
    "images/Rose Carriage - 25,000.png",
    "images/Lion - 29,999.png",
    "images/TikTok Universe - 44,999.png"
  ];

  List<bool> tappedCases = List.generate(26, (index) => false);
  int round = 1; // Keep track of the current round
  int maxCasesPerRound = 6; // Number of cases to choose in the first round
  List<int> selectedCases = []; // Track selected cases in each round
  List<int> revealedCases = []; // Track revealed case indices
  int bankerOffer = 0;

  @override
  void initState() {
    super.initState();
    shuffleCases();
  }

  void shuffleCases() {
    setState(() {
      cases.shuffle(Random());
      priceImages.shuffle(Random());
    });
  }

  void onCaseTapped(int index, PriceController priceController) {
    if (selectedCases.length < maxCasesPerRound) {
      setState(() {
        selectedCases.add(index);
        tappedCases[index] = true; // Mark this case as tapped
        revealedCases.add(index); // Add to revealed cases
      });
      priceController.playMusic("audio/boxopen.mp3");
    }

    // Check if the user has selected the max number of cases for the current round
    if (selectedCases.length == maxCasesPerRound) {
      _showBankerOffer();
    }
  }

  // Show the Banker’s offer popup after opening cases
  void _showBankerOffer() {
    // Example calculation for Banker’s offer (you can customize it further)
    bankerOffer =
        Random().nextInt(10000) + 5000; // Random example between 5000 to 15000

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
      if (round == 1) {
        maxCasesPerRound = 5; // 5 cases for round 2
      } else if (round == 2) {
        maxCasesPerRound = 4; // 4 cases for round 3
      } else if (round == 3) {
        maxCasesPerRound = 3; // 3 cases for round 4
      }
      round++;
      selectedCases.clear(); // Clear selected cases for the new round
      tappedCases = List.generate(26, (index) => false); // Reset tapped cases
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
                Navigator.pop(context); // Go back to main page or restart
              },
              child: Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  Widget buildGridView(List<String> items, PriceController priceController) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          String image = items[index];
          // Display the prize image only for tapped and revealed cases
          return GestureDetector(
            onTap: () => onCaseTapped(index, priceController),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: revealedCases.contains(index)
                    ? Image.asset(
                        priceImages[index],
                        fit: BoxFit.contain,
                      ) // Show the prize image for revealed cases
                    : Image.asset(
                        image,
                        fit: BoxFit.contain,
                      ), // Show the case image initially
              ),
            ),
          );
        },
      ),
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
                                child: buildGridView(cases, priceController)),
                            Image.asset("images/6 Cases To Open.png")
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
