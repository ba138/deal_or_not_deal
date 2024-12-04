import 'dart:async';

import 'package:deal_or_not_deal/pages/splash_page/splash_page.dart';
import 'package:deal_or_not_deal/utills/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class PriceController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  late AudioPlayer clappingPlayer; // Separate player for clapping sound
  late AudioPlayer ringPlayer; // Separate player for ringing sound

  // Reactive lists to manage the case and price images
  var caseDynamic = <String>[].obs;
  var priceImagesDynamic = <String>[].obs;
  var priceListOneDynamic = <Map<String, dynamic>>[].obs;
  var priceListTwoDynamic = <Map<String, dynamic>>[].obs;

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

  Future<void> onCaseTapped(int index) async {
    if (!tappedCases[index] && selectedCases.length < maxCasesPerRound.value) {
      tappedCases[index] = true;
      selectedCases.add(index);

      // Reveal the case and price image
      revealedCases.add(index);

      // Play the clapping sound in a loop
      await playClappingSound();

      // Show the revealed price image temporarily
      String revealedImage = priceImagesDynamic[index];
      Completer<void> completer = Completer<void>();

      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("You revealed:"),
              Image.asset(revealedImage), // Display the revealed price image
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                completer.complete();
                Get.back();
              },
              child: const Text("OK"),
            ),
          ],
        ),
        barrierDismissible: false, // Prevent dismissal when tapping outside
      );

      // Wait for the user to acknowledge the dialog
      await completer.future;

      // Stop the clapping sound
      await stopClappingSound();

      // Remove the case and price image after confirmation
      caseDynamic.removeAt(index);
      priceImagesDynamic.removeAt(index);

      // Remove the image from price lists
      priceListOneDynamic
          .removeWhere((price) => price['image'] == revealedImage);
      priceListTwoDynamic
          .removeWhere((price) => price['image'] == revealedImage);

      // Update the UI after changes
      update();

      // Check if the maximum number of cases have been selected
      if (selectedCases.length == maxCasesPerRound.value) {
        await playRingSound();
        Future.delayed(const Duration(seconds: 2), _showBankerOffer);
      }
    }
  }

  void _showBankerOffer() {
    bankerOffer.value = Random().nextInt(10000) + 5000; // Example banker offer

    // Show a dialog with the banker's offer
    Get.dialog(
      AlertDialog(
        title: const Text("Banker’s Offer"),
        content: Text(
            "The banker offers you \$${bankerOffer.value}. Do you accept?"),
        actions: [
          TextButton(
            onPressed: () async {
              await stopRingSound(); // Stop the ringing sound
              Get.back(); // Close the dialog
              _endGame();
            },
            child: const Text("Deal"),
          ),
          TextButton(
            onPressed: () async {
              await stopRingSound(); // Stop the ringing sound
              Get.back(); // Close the dialog
              nextRound();
            },
            child: const Text("No Deal"),
          ),
        ],
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
              Get.back(); // Close the dialog
              // Reset all states and restart the app
              Get.offAll(() => const SplashPage());
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

  @override
  void onClose() {
    audioPlayer.dispose();
    clappingPlayer.dispose();
    ringPlayer.dispose();
    super.onClose();
  }
}
