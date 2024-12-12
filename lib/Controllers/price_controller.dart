import 'dart:async';

import 'package:deal_or_not_deal/pages/FirstPage/first_page.dart';
import 'package:deal_or_not_deal/utills/colors.dart';
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
  RxString? removedCaseImage;
  RxString? removedPriceImage;
  RxString removedPriceImage2 = ''.obs;
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
  RxBool isSwap = false.obs;
  RxBool showbuttons = false.obs;
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
        playRingSound();
        Completer<void> completer = Completer<void>();

        _showPhoneCall(completer);
        await completer.future;
        Get.back();
        _showBankerOffer();
      }
    }
  }

  void _showPhoneCall(Completer completer) {
    Get.dialog(
      Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: 500,
            width: 500,
            child: Column(
              children: [
                const Icon(
                  Icons.phone_in_talk_rounded,
                  size: 300,
                ),
                InkWell(
                  onTap: () {
                    stopRingSound();
                    completer.complete();
                  },
                  child: Container(
                    height: 56,
                    width: 180,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondPrimaryColor
                        ],
                        begin: Alignment.centerLeft, // Start from the left
                        end: Alignment.centerRight, // End at the right
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Get Offer",
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
          )),
      barrierDismissible: false, // Prevent dismissal when tapping outside
    );
  }

  void _showBankerOffer() {
    List<int> priceValues = [];

    for (var item in priceListOneDynamic) {
      if (item['image'] != "") {
        priceValues.add(int.parse(item['priceValue'].replaceAll(",", "")));
      }
    }

    for (var item in priceListTwoDynamic) {
      if (item['image'] != "") {
        priceValues.add(int.parse(item['priceValue'].replaceAll(",", "")));
      }
    }

    // Calculate RMS value
    if (priceValues.isNotEmpty) {
      double rms = sqrt(priceValues
                  .map((value) => value * value) // Square each value
                  .reduce((a, b) => a + b) / // Sum all squared values
              priceValues.length // Divide by the number of values
          ); // Take the square root

      bankerOffer.value = rms.toInt(); // Set the banker offer to the RMS value
    } else {
      bankerOffer.value = Random().nextInt(10000) + 5000; // Fallback value
    }

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
                      ringPlayer.dispose();
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
                      int emptyCount =
                          priceImagesDynamic.where((item) => item == "").length;
                      debugPrint(
                          "this is the lenght of caseDynamic:$emptyCount");
                      if (emptyCount == 24) {
                        showbuttons.value = true;
                        debugPrint(
                            "this is value of showbutton:${showbuttons.value}");
                        stopRingSound(); // Stop the ringing sound
                        Get.back();
                        update();
                      } else {
                        stopRingSound(); // Stop the ringing sound
                        Get.back(); // Close the dialog
                        nextRound();
                      }
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

  void swapElements(
    String caseImage,
  ) {
    // Temporary variables to hold the values being swapped out
    isSwap.value = true;
    // Find the first non-empty element in caseDynamic
    int caseIndex = caseDynamic.indexWhere((element) => element.isNotEmpty);

    // Find the first non-empty element in priceImagesDynamic
    int priceIndex =
        priceImagesDynamic.indexWhere((element) => element.isNotEmpty);

    if (caseIndex != -1 && priceIndex != -1) {
      // Assign the current non-empty values to the temporary variables
      userCaseImage.value = caseDynamic[caseIndex];
      removedPriceImage?.value = priceImagesDynamic[priceIndex];

      // Swap the provided values into the lists
      debugPrint("this is the image${removedPriceImage2.value}");
      caseDynamic[caseIndex] = caseImage;
      priceImagesDynamic[priceIndex] = removedPriceImage2.value;

      // Notify the UI about the updates
      caseDynamic.refresh();
      priceImagesDynamic.refresh();

      // Debugging: Print the swapped values
      debugPrint("Swapped caseImage: $removedCaseImage with $caseImage");
      debugPrint(
          "Swapped priceImage: $removedPriceImage with ${removedPriceImage2.value}");
    } else {
      // Handle the case where no non-empty element is found
      debugPrint("No non-empty elements found to swap.");
    }
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

    if (caseDynamic.contains(targetCase)) {
      // Remove the string and assign it to selectedCaseImage
      userCaseImage.value = targetCase;
      caseDynamic.remove(targetCase);
      debugPrint("Selected case image: $userCaseImage.value");
      debugPrint("Updated caseDynamic: $caseDynamic");
    } else {
      debugPrint("Target string not found in caseDynamic.");
    }

    // Randomly select a price image and remove it from priceImagesDynamic
    if (priceImagesDynamic.isNotEmpty) {
      // Assign the value to a temporary string variable before removal
      removedPriceImage2.value = priceImagesDynamic.first;

      // Remove the selected price image and update the userCasePriceImage
      userCasePriceImage.value = priceImagesDynamic.removeAt(0);

      // Debugging: Log the removed and updated lists
      debugPrint("Removed price image: $removedPriceImage");
      debugPrint("Selected price image: ${userCasePriceImage.value}");
      debugPrint("Updated priceImagesDynamic: $priceImagesDynamic");

      // Optionally remove the selected price image from other dynamic lists
      priceListOneDynamic
          .removeWhere((item) => item['image'] == removedPriceImage);
      priceListTwoDynamic
          .removeWhere((item) => item['image'] == removedPriceImage);

      // Debugging: Confirm removal from other lists
      debugPrint(
          "Updated priceListOneDynamic after removal: $priceListOneDynamic");
      debugPrint(
          "Updated priceListTwoDynamic after removal: $priceListTwoDynamic");
    } else {
      debugPrint("Price images list is empty.");
    }
  }

  Future<void> revealPlayerCase() async {
    Map<String, dynamic>? matchedItem;

// First, check in priceListOne
    matchedItem = priceListOne.firstWhere(
      (item) => item['image'] == removedPriceImage2.value,
      orElse: () => <String, dynamic>{}, // Return an empty map instead of null
    );

// If no match is found in priceListOne, check in priceListTwo
    if (matchedItem.isEmpty) {
      matchedItem = priceListTwo.firstWhere(
        (item) => item['image'] == removedPriceImage2.value,
        orElse: () =>
            <String, dynamic>{}, // Return an empty map instead of null
      );
    }

// Ensure a match is found in one of the lists
    if (matchedItem.isNotEmpty) {
      // Parse the priceValue and remove any commas
      int priceValue = int.parse(matchedItem['priceValue'].replaceAll(",", ""));

      // Compare the value and play the appropriate sound
      if (priceValue > 2988) {
        await playClappingSound(); // Play clapping sound for higher values
      } else {
        // await playDifferentSound(); // Play a different sound for lower values
        drumRollSound();
      }
    } else {
      // Handle the case where no match is found in both lists
      debugPrint('No matching item found for image: $removedPriceImage');
    }
    for (var item in priceListOneDynamic) {
      if (item['image'] == removedPriceImage2.value) {
        item['image'] = ""; // Update the image
        priceListOneDynamic.refresh(); // Notify UI
        break;
      }
    }

    for (var item in priceListTwoDynamic) {
      if (item['image'] == removedPriceImage2.value) {
        item['image'] = ""; // Update the image
        priceListTwoDynamic.refresh(); // Notify UI
        break;
      }
    }

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
                removedPriceImage2.value,
                height: 400,
                width: 400,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    clappingPlayer.dispose();
    ringPlayer.dispose();
    super.dispose();
  }
}
