import 'dart:async';

import 'package:deal_or_not_deal/pages/FirstPage/first_page.dart';
import 'package:deal_or_not_deal/utills/colors.dart';
import 'package:deal_or_not_deal/utills/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class PriceController extends GetxController {
  RxList<dynamic> priceListOneDynamic;
  RxList<dynamic> priceListTwoDynamic;
  String targetCase;
  PriceController({
    required this.priceListOneDynamic,
    required this.priceListTwoDynamic,
    required this.targetCase,
  });
  late SoLoud soloud;
  late SoundHandle soundHandle;
  late AudioSource source;

  RxString? removedCaseImage;
  RxString? removedPriceImage;
  RxString removedPriceImage2 = ''.obs;
  // Reactive lists to manage the case and price images
  var caseDynamic = <String>[].obs;
  var priceImagesDynamic = <String>[].obs;

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
    try {
      // Initialize the audio engine
      soloud = SoLoud.instance;
      await soloud.init();

      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/claping.mp3');
      soundHandle = await soloud.play(source, looping: true, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> drumRollSound() async {
    try {
      // Initialize the audio engine
      soloud = SoLoud.instance;
      await soloud.init();

      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/drum_roll.mp3');
      soundHandle = await soloud.play(source, looping: false, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> playRingSound() async {
    try {
      // Initialize the audio engine
      soloud = SoLoud.instance;
      await soloud.init();

      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/phone Ring.mp3');
      soundHandle = await soloud.play(source, looping: true, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> playThinkingSound() async {
    try {
      // Initialize the audio engine
      soloud = SoLoud.instance;
      await soloud.init();

      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/thinking_music.mp3');
      soundHandle = await soloud.play(source, looping: true, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> stopRingSound() async {
    await soloud.stop(soundHandle);

    // Deinitialize the audio engine
    await soloud.disposeSource(source);
    // await ringPlayer.stop();
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
      matchedItem = checkOne.firstWhere(
        (item) => item['image'] == revealedImage,
        orElse: () =>
            <String, dynamic>{}, // Return an empty map instead of null
      );

// If no match is found in priceListOne, check in priceListTwo
      if (matchedItem.isEmpty) {
        matchedItem = checkTwo.firstWhere(
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
          drumRollSound();
        } else {
          // await playDifferentSound(); // Play a different sound for lower values
          await playClappingSound(); // Play clapping sound for higher values
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
        stopRingSound();
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
        int emptyCount = priceImagesDynamic.where((item) => item == "").length;
        if (emptyCount <= 20) {
          // debugPrint("playing somg");
          // playRingSound();

          Completer<void> completer = Completer<void>();
          debugPrint("Playing ringing sound...");
          // await playRingSound(); // Start ringing

          await _showPhoneCall(completer); // Show phone call dialog
          await completer.future; // Wait for user action

          stopRingSound(); // Stop ringing after user action
          debugPrint("Ringing sound stopped");

          Get.back();
          playThinkingSound();
          _showBankerOffer();
        } else if (emptyCount == 24) {
          showbuttons.value = true;
          debugPrint("this is value of showbutton:${showbuttons.value}");
          stopRingSound(); // Stop the ringing sound
          Get.back();
          playThinkingSound();

          update();
        } else {
          stopRingSound(); // Stop the ringing sound
          Get.back(); // Close the dialog
          nextRound();
        }
      }
    }
  }

  Future<void> _showPhoneCall(Completer<void> completer) async {
    await playRingSound(); // Ensure sound starts before the dialog

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
                    completer.complete();
                    stopRingSound();
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

  void _showConguritaionDialog(int amount) {
    Get.dialog(Dialog(
      child: SizedBox(
        height: 300,
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "congratulations",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "You have won $amount",
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                Get.back();
                revealPlayerCase();
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
                    begin: Alignment.centerLeft, // Start from the left
                    end: Alignment.centerRight, // End at the right
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Reveal Box",
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
              height: 50,
            ),
          ],
        ),
      ),
    ));
  }

  void _showBankerOffer() {
    List<int> priceValues = [];

    // Collect all remaining case values
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

    // If there are remaining values, calculate the offer

    // Step 1: Calculate the average value
    double average = priceValues.reduce((a, b) => a + b) / priceValues.length;

    // Step 2: Adjust for high-value risk (e.g., give more weight to higher values)
    int maxValue = priceValues.reduce((a, b) => a > b ? a : b);
    double riskAdjustment = (maxValue > 10000) ? 0.8 : 1.0;

    // Step 3: Psychological manipulation (offer less to tempt but not too generous)
    double psychologicalFactor =
        0.85; // Bank offers ~85% of the adjusted average

    // Final banker offer
    double offer = average * riskAdjustment * psychologicalFactor;

    // Set the banker offer value
    bankerOffer.value = offer.toInt();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(Get.context!).size.width / 1.8,
          height: MediaQuery.of(Get.context!).size.width / 2,
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
                    "${bankerOffer.value}",
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
                      Get.back(); // Close the dialog
                      stopRingSound();
                      _showConguritaionDialog(bankerOffer.value);
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
                        playThinkingSound();
                        Get.back();
                        update();
                      } else {
                        stopRingSound(); // Stop the ringing sound
                        playClappingSound();
                        Future.delayed(
                            const Duration(
                              seconds: 4,
                            ), () {
                          stopRingSound(); // Stop the ringing sound
                        });
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
    stopRingSound(); // Stop the ringing sound

    // Find the first non-empty element in priceImagesDynamic
    int priceIndex =
        priceImagesDynamic.indexWhere((element) => element.isNotEmpty);

    if (caseIndex != -1 && priceIndex != -1) {
      // Assign the current non-empty values to the temporary variables
      userCaseImage.value = caseDynamic[caseIndex];
      removedPriceImage?.value = priceImagesDynamic[priceIndex];

      // Swap the provided values into the lists

      caseDynamic[caseIndex] = caseImage;
      priceImagesDynamic[priceIndex] = removedPriceImage2.value;

      // Notify the UI about the updates
      caseDynamic.refresh();
      priceImagesDynamic.refresh();
    } else {
      // Handle the case where no non-empty element is found
      debugPrint("No non-empty elements found to swap.");
    }
  }

  void getData() {
    // Reset the caseDynamic list to its original state
    caseDynamic.value = List.from(cases);

    // Reset price images to their original state
    priceImagesDynamic.value = List.from(priceImages);

    // Shuffle the lists for randomness
    priceImagesDynamic.shuffle();

    // Continue with the rest of your logic
    if (caseDynamic.contains(targetCase)) {
      userCaseImage.value = targetCase;
      caseDynamic.remove(targetCase);
    } else {
      debugPrint("Target string not found in caseDynamic.");
    }

    // Handle price image selection and removal
    if (priceImagesDynamic.isNotEmpty) {
      removedPriceImage2.value = priceImagesDynamic.first;
      userCasePriceImage.value = priceImagesDynamic.removeAt(0);
    } else {
      debugPrint("Price images list is empty.");
    }

    // Call the updateDynamicLists method to refresh price lists
//  priceListOneDynamic
//       ..clear()
//       ..addAll(priceListOne);

    // Debug to confirm the operation
    debugPrint("priceListOneDynamic after refresh: $priceListOneDynamic");

    // Clear and refresh priceListTwoDynamic
    // priceListTwoDynamic
    //   ..clear()
    //   ..addAll(priceListTwo);

    // Debug to confirm the operation
    debugPrint("priceListTwoDynamic after refresh: $priceListTwoDynamic");
  }

  Future<void> revealPlayerCase() async {
    Map<String, dynamic>? matchedItem;
    stopRingSound(); // Stop the ringing sound

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
              const Text(
                "congratulations",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
    Future.delayed(const Duration(seconds: 5), () {
      // Navigate to the FirstPage
      Get.offAll(() => const FirstPage());
    });
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
