import 'dart:async';

import 'package:deal_or_not_deal/pages/FirstPage/first_page.dart';
import 'package:deal_or_not_deal/utills/colors.dart';
import 'package:deal_or_not_deal/utills/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
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
      Future.delayed(const Duration(seconds: 3), () async {
        await soloud.stop(soundHandle);

        // Deinitialize the audio engine
        await soloud.disposeSource(source);
      });
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
    // clappingPlayer = AudioPlayer();
    // await clappingPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
    // await clappingPlayer.play(DeviceFileSource("audio/claping.mp3"));

    // // Stop the sound after 3 seconds
    // Future.delayed(const Duration(seconds: 3), () async {
    //   await clappingPlayer.stop();
    // });
  }

  Future<void> drumRollSound() async {
    try {
      // Initialize the audio engine
      soloud = SoLoud.instance;
      await soloud.init();

      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/drum_roll.mp3');
      soundHandle = await soloud.play(source, looping: false, volume: 1.0);
      Future.delayed(const Duration(seconds: 3), () async {
        await soloud.stop(soundHandle);

        // Deinitialize the audio engine
        await soloud.disposeSource(source);
      });
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
    // dumroll = AudioPlayer();
    // await dumroll.play(DeviceFileSource("audio/drum_roll.mp3"));

    // // Stop the sound after 3 seconds
    // Future.delayed(const Duration(seconds: 3), () async {
    //   await dumroll.stop();
    // });
  }

  Future<void> stopClappingSound() async {
    await clappingPlayer.stop();
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
    // ringPlayer = AudioPlayer();
    // await ringPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
    // await ringPlayer.play(DeviceFileSource("audio/phone Ring.mp3"));
  }

  Future<void> stopRingSound() async {
    await soloud.stop(soundHandle);

    // Deinitialize the audio engine
    await soloud.disposeSource(source);
    // await ringPlayer.stop();
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
          playRingSound();
          Completer<void> completer = Completer<void>();

          _showPhoneCall(completer);
          await completer.future;
          Get.back();
          _showBankerOffer();
        } else if (emptyCount == 24) {
          showbuttons.value = true;
          debugPrint("this is value of showbutton:${showbuttons.value}");
          stopRingSound(); // Stop the ringing sound
          Get.back();
          update();
        } else {
          stopRingSound(); // Stop the ringing sound
          Get.back(); // Close the dialog
          nextRound();
        }
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
              "Congurataion",
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
                      ringPlayer.dispose();
                      audioPlayer.dispose();
                      // clappingPlayer.dispose();
                      // ringPlayer.dispose();
                      Get.back(); // Close the dialog
                      _showConguritaionDialog(bankerOffer.value);
                      // _endGame();
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

  // void updateDynamicLists() {
  //   // Clear and refresh priceListOneDynamic

  //   // Debugging additional state if needed
  //   debugPrint("Static priceListOne: $priceListOne");
  //   debugPrint("Static priceListTwo: $priceListTwo");
  // }

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
    Future.delayed(const Duration(seconds: 5), () {
      // Assign static lists to dynamic lists
      // priceListOneDynamic.assignAll(priceListOne);
      // priceListTwoDynamic.assignAll(priceListTwo);

      // // Update empty image values in priceListOneDynamic
      // for (int i = 0; i < priceListOneDynamic.length; i++) {
      //   if (priceListOneDynamic[i]['image'] == '') {
      //     // Find corresponding static item by priceId
      //     var staticItem = priceListOne.firstWhere(
      //       (item) => item['priceId'] == priceListOneDynamic[i]['priceId'],
      //       orElse: () =>
      //           <String, dynamic>{}, // Provide an empty map if not found
      //     );

      //     if (staticItem.isNotEmpty) {
      //       priceListOneDynamic[i] = {
      //         ...priceListOneDynamic[i],
      //         'image': staticItem['image'], // Update the image value
      //       };
      //     }
      //   }
      // }

      // Update empty image values in priceListTwoDynamic
      // for (int i = 0; i < priceListTwoDynamic.length; i++) {
      //   if (priceListTwoDynamic[i]['image'] == '') {
      //     // Find corresponding static item by priceId
      //     var staticItem = priceListTwo.firstWhere(
      //       (item) => item['priceId'] == priceListTwoDynamic[i]['priceId'],
      //       orElse: () =>
      //           <String, dynamic>{}, // Provide an empty map if not found
      //     );

      //     if (staticItem.isNotEmpty) {
      //       priceListTwoDynamic[i] = {
      //         ...priceListTwoDynamic[i],
      //         'image': staticItem['image'], // Update the image value
      //       };
      //     }
      //   }
      // }

      // // Debug to verify updates
      // debugPrint("Updated List One: $priceListOneDynamic");
      // debugPrint("Updated List Two: $priceListTwoDynamic");

      // Navigate to the FirstPage
      Get.offAll(() => const FirstPage());
    });
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    clappingPlayer.dispose();
    ringPlayer.dispose();
    super.dispose();
  }
}
