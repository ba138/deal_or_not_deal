import 'dart:async';

import 'package:deal_or_not_deal/pages/FirstPage/first_page.dart';
import 'package:deal_or_not_deal/utills/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class PriceController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  late AudioPlayer clappingPlayer; // Separate player for clapping sound
  late AudioPlayer ringPlayer; // Separate player for ringing sound
  late AudioPlayer dumroll;

  // Reactive lists to manage the case and price images
  var caseDynamic = <String>[].obs;
  var priceImagesDynamic = <String>[].obs;
  RxList<Map<String, dynamic>> priceListOneDynamic = RxList([]);
  RxList<Map<String, dynamic>> priceListTwoDynamic = RxList([]);
  RxString userCaseImage = "".obs;
  RxString userCasePriceImage = "".obs;
  var tappedCases = List.generate(26, (index) => false).obs;
  var round = 1.obs;
  var maxCasesPerRound = 6.obs;
  var selectedCases = <int>[].obs;
  var revealedCases = <int>[].obs;
  var bankerOffer = 0.obs;
  var roundImages = <String>[
    "images/6 Cases To Open.png",
    "images/5 Cases To Open.png",
    "images/4 Cases To Open.png",
    "images/3 Cases To Open.png",
    "images/2 Cases To Open.png",
    "images/1 Case To Open.png"
  ].obs;

  Future<void> playClappingSound() async {
    clappingPlayer = AudioPlayer();
    await clappingPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await clappingPlayer.play(DeviceFileSource("audio/claping.mp3"));

    // Stop the sound after 3 seconds
    Future.delayed(const Duration(seconds: 4), () async {
      await clappingPlayer.stop();
    });
  }

  Future<void> drumRollSound() async {
    dumroll = AudioPlayer();
    await dumroll.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await dumroll.play(DeviceFileSource("audio/drum_roll.mp3"));

    // Stop the sound after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      await dumroll.stop();
    });
  }

  Future<void> stopClappingSound() async {
    await clappingPlayer.stop();
  }

  Future<void> playRingSound() async {
    ringPlayer = AudioPlayer();
    await ringPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await ringPlayer.play(DeviceFileSource("audio/phone Ring.mp3"));
    Future.delayed(const Duration(seconds: 8), () async {
      await ringPlayer.stop();
    });
  }

  Future<void> playBankerOfferSound() async {
    ringPlayer = AudioPlayer();
    await ringPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await ringPlayer.play(DeviceFileSource("audio/phone Ring.mp3"));
  }

  Future<void> stopRingSound() async {
    await ringPlayer.stop();
  }

  Future<void> stopAllSounds() async {
    await clappingPlayer.stop();

    await ringPlayer.stop();
  }

  Future<void> onCaseTapped(int index) async {
    if (!tappedCases[index] && selectedCases.length < maxCasesPerRound.value) {
      tappedCases[index] = true;
      selectedCases.add(index);

      // Reveal the case and price image
      revealedCases.add(index);

      String revealedImage = priceImagesDynamic[index];

      // Initialize matchedItem to null
      Map<String, dynamic>? matchedItem;

// First, check in priceListOne
      matchedItem = priceListOne.firstWhere(
        (item) => item['image'] == revealedImage,
        orElse: () =>
            <String, dynamic>{}, // Return an empty map instead of null
      );

// If no match is found in priceListOne, check in priceListTwo
      if (matchedItem.isEmpty) {
        matchedItem = priceListTwo.firstWhere(
          (item) => item['image'] == revealedImage,
          orElse: () =>
              <String, dynamic>{}, // Return an empty map instead of null
        );
      }

// Ensure a match is found in one of the lists
      if (matchedItem.isNotEmpty) {
        // Parse the priceValue and remove any commas
        int priceValue =
            int.parse(matchedItem['priceValue'].replaceAll(",", ""));

        // Compare the value and play the appropriate sound
        if (priceValue > 2988) {
          await playClappingSound(); // Play clapping sound for higher values
        } else {
          // await playDifferentSound(); // Play a different sound for lower values
          drumRollSound();
        }
      } else {
        // Handle the case where no match is found in both lists
        debugPrint('No matching item found for image: $revealedImage');
      }

      Completer<void> completer = Completer<void>();

      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 500,
            width: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("images/caseopen.png")),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  revealedImage,
                  height: 400,
                  width: 400,
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      Future.delayed(const Duration(seconds: 3), () {
        completer.complete();
        Get.back();
      });

      // Wait for user confirmation
      await completer.future;

      // Mark the case as used instead of removing it
      priceImagesDynamic[index] = ""; // Clear the image to indicate it's used
      caseDynamic[index] = ""; // Clear the case

      // Update the image value to an empty string in dynamic lists
      for (var item in priceListOneDynamic) {
        if (item['image'] == revealedImage) {
          item['image'] = ""; // Update the image
          priceListOneDynamic.refresh(); // Notify UI
          break;
        }
      }

      for (var item in priceListTwoDynamic) {
        if (item['image'] == revealedImage) {
          item['image'] = ""; // Update the image
          priceListTwoDynamic.refresh(); // Notify UI
          break;
        }
      }

      // Check if the maximum number of cases have been selected
      if (selectedCases.length == maxCasesPerRound.value) {
        // Check if it is the last round
        if (round.value == roundImages.length) {
          // Navigate to SplashPage for the final round
          Get.offAll(() => const FirstPage());
          return; // Stop further execution
        }

        Future.delayed(const Duration(seconds: 3), () async {
          await playRingSound();
        });

        Future.delayed(const Duration(seconds: 3), _showBankerOffer);
      }
    }
  }

  void _showBankerOffer() {
    bankerOffer.value = Random().nextInt(10000) + 5000; // Example banker offer

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(Get.context!).size.width / 1.8,
          height: MediaQuery.of(Get.context!).size.width / 1.5,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image:
                  AssetImage('images/Default Banker.jpg'), // Path to your image
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // TextField showing banker's offer
              const Center(
                child: Text(
                  "BANK OFFER",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "\$${bankerOffer.value}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      await ringPlayer.stop();
                      audioPlayer.dispose();
                      clappingPlayer.dispose();
                      ringPlayer.dispose();
                      Get.back(); // Close the dialog
                      _endGame();
                    },
                    child: Container(
                      height: 56,
                      width: 200,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                      ),
                      child: const Center(
                        child: Text(
                          "Deal",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      stopRingSound(); // Stop the ringing sound
                      Get.back(); // Close the dialog
                      nextRound();
                    },
                    child: Container(
                      height: 56,
                      width: 200,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                      child: const Center(
                        child: Text(
                          "No Deal",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // Prevent dismissal when tapping outside
    );
  }

  // Function to end the game and show the final win amount
  void _endGame() {
    Get.dialog(
      AlertDialog(
        title: const Text("Game Over"),
        content: Text("Congratulations! You won \$${bankerOffer.value}."),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Get.back();

              // Update the price lists and notify listeners
              priceListOneDynamic.refresh(); // Refresh priceListOneDynamic
              priceListTwoDynamic.refresh(); // Refresh priceListTwoDynamic
              update(); // Notify GetX controller to update UI

              // Navigate to SplashPage after the dialog closes
              Future.delayed(const Duration(milliseconds: 300), () {
                Get.offAll(() => const FirstPage());
              });
            },
            child: const Text("Exit"),
          ),
        ],
      ),
      barrierDismissible: false, // Prevent dismissal when tapping outside
    );
  }

  void nextRound() {
    if (round.value < roundImages.length) {
      maxCasesPerRound.value = roundImages.length - round.value.toInt();
      round.value++;
    }
    selectedCases.clear();
  }

  void getData(String targetCase) {
    // Reset the lists to their original states (if needed)
    caseDynamic.value = List.from(cases); // Reset to original case images
    priceImagesDynamic.value =
        List.from(priceImages); // Reset to original price images

    // Update dynamic lists from the static ones
    priceListOneDynamic.value = List.from(priceListOne);
    priceListTwoDynamic.value = List.from(priceListTwo);

    // Debugging: Check contents of dynamic lists
    debugPrint(
        "this is the length of priceListOneDynamic: ${priceListOneDynamic.length}");
    debugPrint(
        "this is the contents of priceListOneDynamic: $priceListOneDynamic");

    debugPrint(
        "this is the length of priceListTwoDynamic: ${priceListTwoDynamic.length}");
    debugPrint(
        "this is the contents of priceListTwoDynamic: $priceListTwoDynamic");

    // Shuffle the lists for randomness
    priceImagesDynamic.shuffle();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    clappingPlayer.dispose();
    ringPlayer.dispose();
    super.dispose();
  }
}
