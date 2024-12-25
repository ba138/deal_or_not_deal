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
  late SoLoud soloud2;
  late SoundHandle soundHandle2;
  late AudioSource source2;
  late SoLoud soloud3;
  late SoundHandle soundHandle3;
  late AudioSource source3;
  late SoLoud soloudRing;
  late SoundHandle soundHandleRing;
  late AudioSource sourceRing;

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
    "images/1 Case To Open.png",
    "images/5 Cases To Open.png",
    "images/4 Cases To Open.png",
    "images/3 Cases To Open.png",
    "images/2 Cases To Open.png",
    "images/1 Case To Open.png",
    "images/4 Cases To Open.png",
    "images/3 Cases To Open.png",
    "images/2 Cases To Open.png",
    "images/1 Case To Open.png",
    "images/3 Cases To Open.png",
    "images/2 Cases To Open.png",
    "images/1 Case To Open.png",
    "images/2 Cases To Open.png",
    "images/1 Case To Open.png",
    "images/2 Cases To Open.png",
    "images/1 Case To Open.png",
    "images/2 Cases To Open.png",
    "images/1 Case To Open.png",
    "images/1 Case To Open.png",
  ].obs;
  Rx<int> roundCount = 0.obs;
// Declare these at the top of your class or as part of the state management
  Rx<int> currentRound = 0.obs; // Track the current round, starting from 1
  Rx<int> remainingCases = 24.obs;
  Future<void> playClappingSound() async {
    try {
      // Initialize the audio engine
      // soloud = SoLoud.instance;

      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/claping.mp3');
      soundHandle = await soloud.play(source, looping: false, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> playClappingSound4() async {
    try {
      // Initialize the audio engine
      // soloud = SoLoud.instance;

      // Load the audio asset and play with looping
      source2 = await soloud2.loadAsset('audio/claping.mp3');
      soundHandle2 = await soloud2.play(source, looping: false, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> playClappingSound3() async {
    try {
      // Initialize the audio engine
      // soloud = SoLoud.instance;

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
      // soloud = SoLoud.instance;
      // await soloud.init();

      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/drum_roll.mp3');
      soundHandle = await soloud.play(source, looping: false, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> playRingSound2() async {
    try {
      // Load the audio asset and play with looping
      sourceRing = await soloudRing.loadAsset('audio/phone Ring.mp3');
      print('Loaded MP3 asset successfully');

      soundHandleRing =
          await soloudRing.play(sourceRing, looping: true, volume: 1.0);
      print('Started playing audio');
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> playRingSound() async {
    try {
      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/phone Ring.mp3');
      print('Loaded MP3 asset successfully');

      soundHandle = await soloud.play(source, looping: true, volume: 1.0);
      print('Started playing audio');
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> playThinkingSound() async {
    try {
      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/thinking_music.mp3');
      soundHandle = await soloud.play(source, looping: true, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> playThinkingSound2() async {
    try {
      // Load the audio asset and play with looping
      source3 = await soloud3.loadAsset('audio/thinking_music.mp3');
      soundHandle3 = await soloud3.play(source, looping: true, volume: 1.0);
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

  Future<void> stopRingSound3() async {
    await soloud3.stop(soundHandle);

    // Deinitialize the audio engine
    await soloud3.disposeSource(source);
    // await ringPlayer.stop();
  }

  Future<void> stopRingSound2() async {
    await soloud2.stop(soundHandle2);

    // Deinitialize the audio engine
    await soloud2.disposeSource(source2);
    // await ringPlayer.stop();
  }

  Future<void> onCaseTapped(int index) async {
    roundCount.value++;

    if (!tappedCases[index]) {
      tappedCases[index] = true; // Mark the case as tapped
      selectedCases.add(index); // Add the case to selected
      revealedCases.add(index); // Mark the case as revealed
      String revealedImage = priceImagesDynamic[index];

      // Find matched item
      Map<String, dynamic>? matchedItem = checkOne.firstWhere(
        (item) => item['image'] == revealedImage,
        orElse: () => <String, dynamic>{},
      );

      if (matchedItem.isEmpty) {
        matchedItem = checkTwo.firstWhere(
          (item) => item['image'] == revealedImage,
          orElse: () => <String, dynamic>{},
        );
      }

      // Handle sound effects based on matched item
      if (matchedItem.isNotEmpty) {
        int priceValue =
            int.parse(matchedItem['priceValue'].replaceAll(",", ""));
        if (priceValue >= 2988) {
          drumRollSound();
        } else {
          await playClappingSound();
        }
      }

      // Show the case opening dialog
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

      // Close the dialog after a delay
      Future.delayed(const Duration(seconds: 3), () {
        stopRingSound();
        completer.complete();
        Get.back();
      });

      await completer.future;

      // Mark the case as used
      priceImagesDynamic[index] = "";
      caseDynamic[index] = "";

      // Update dynamic lists
      for (var item in priceListOneDynamic) {
        if (item['image'] == revealedImage) {
          item['image'] = "";
          priceListOneDynamic.refresh();
          break;
        }
      }
      for (var item in priceListTwoDynamic) {
        if (item['image'] == revealedImage) {
          item['image'] = "";
          priceListTwoDynamic.refresh();
          break;
        }
      }

      // Calculate the number of empty cases
      int emptyCount = priceImagesDynamic.where((item) => item.isEmpty).length;
      if (emptyCount == 6) {
        Completer<void> phoneCallCompleter = Completer<void>();
        await _showPhoneCall(phoneCallCompleter);
        await phoneCallCompleter.future;

        Get.back();
        playThinkingSound();
        _showBankerOffer();
      } else if (emptyCount == 11) {
        Completer<void> phoneCallCompleter = Completer<void>();
        await _showPhoneCall(phoneCallCompleter);
        await phoneCallCompleter.future;

        Get.back();
        playThinkingSound();
        _showBankerOffer();
      } else if (emptyCount == 15) {
        Completer<void> phoneCallCompleter = Completer<void>();
        await _showPhoneCall(phoneCallCompleter);
        await phoneCallCompleter.future;

        Get.back();
        playThinkingSound();
        _showBankerOffer();
      } else if (emptyCount == 18) {
        Completer<void> phoneCallCompleter = Completer<void>();
        await _showPhoneCall(phoneCallCompleter);
        await phoneCallCompleter.future;

        Get.back();
        playThinkingSound();
        _showBankerOffer();
      } else if (emptyCount == 20) {
        Completer<void> phoneCallCompleter = Completer<void>();
        await _showPhoneCall(phoneCallCompleter);
        await phoneCallCompleter.future;

        Get.back();
        playThinkingSound();
        _showBankerOffer();
      } else if (emptyCount == 22) {
        Completer<void> phoneCallCompleter = Completer<void>();
        await _showPhoneCall(phoneCallCompleter);
        await phoneCallCompleter.future;

        Get.back();
        playThinkingSound();
        _showBankerOffer();
      } else if (emptyCount == 24) {
        Completer<void> phoneCallCompleter = Completer<void>();
        await _showPhoneCall(phoneCallCompleter);
        await phoneCallCompleter.future;

        Get.back();
        Completer<void> playCallCompleter = Completer<void>();

        playThinkingSound2();
        _showBankerOfferForLastRound(playCallCompleter, true);
        await phoneCallCompleter.future;
        showbuttons.value = true;
        debugPrint("Show buttons enabled: ${showbuttons.value}");
        stopRingSound3();
        playThinkingSound();
        update();
      }
    }
  }

  Future<void> _showPhoneCall(Completer<void> completer) async {
    await playRingSound2(); // Ensure sound starts before the dialog

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
                    stopRingSound2();

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
    // await playRingSound();
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
              "Congratulations!",
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
                        // nextRound(casesPerRound);
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

  void _showBankerOfferForLastRound(
    Completer playCallCompleter,
    bool islastRound,
  ) {
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
                      playCallCompleter.complete();
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
                        // nextRound(casesPerRound);
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
    stopRingSound3();
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
        await playClappingSound4(); // Play clapping sound for higher values
      } else {
        // await playDifferentSound(); // Play a different sound for lower values
        // drumRollSound();
        await playClappingSound4(); // Play clapping sound for higher values
      }
    } else {
      // Handle the case where no match is found in both lists
      await playClappingSound4(); // Play clapping sound for higher values

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
                "Congratulations!",
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
    Future.delayed(
        const Duration(
          seconds: 9,
        ), () {
      stopRingSound2();
      // Navigate to the FirstPage
      Get.offAll(() => const FirstPage());
    });
  }

  @override
  void onInit() async {
    getData();
    soloud = SoLoud.instance;
    await soloud.init();
    soloud2 = SoLoud.instance;
    await soloud2.init();
    soloud3 = SoLoud.instance;
    await soloud3.init();
    soloudRing = SoLoud.instance;
    await soloudRing.init();
    super.onInit();
  }
}
