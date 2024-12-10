import 'package:audioplayers/audioplayers.dart';
import 'package:deal_or_not_deal/pages/splash_page/splash_page.dart';
import 'package:deal_or_not_deal/utills/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class SelectUser extends StatefulWidget {
  final List<Map<String, dynamic>> usersName;

  const SelectUser({
    super.key,
    required this.usersName,
  });

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  final RxInt highlightedIndex =
      (-1).obs; // Current highlighted box during animation
  final RxBool animationInProgress = false.obs; // Tracks animation state
  final Random random = Random();
  Map<String, dynamic> selectedUser = {}; // Holds the final selected user data
  final AudioPlayer audioPlayer = AudioPlayer();
  late AudioPlayer userSelectionSound;
  late AudioPlayer startingSound;
  Future<void> playStartingSound() async {
    startingSound = AudioPlayer();
    await startingSound.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await startingSound.play(DeviceFileSource("audio/starting_sound.mp3"));

    // Stop the sound after 3 seconds
  }

  Future<void> stopStartingSoundAndNavigate() async {
    await startingSound.stop();

    // Get.offAll(() => const InputForum());
  }

  Future<void> startUserSelectionSound() async {
    userSelectionSound = AudioPlayer();
    await userSelectionSound.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await userSelectionSound
        .play(DeviceFileSource("audio/player_selection_sound.mp3"));
  }

  Future<void> stopUserSelectionSound() async {
    await userSelectionSound.stop();
  }

  void startSelectionAnimation() async {
    if (animationInProgress.value) return;
    playStartingSound();
    animationInProgress.value = true;
    int cycles = 20; // Number of cycles before the selection stops
    int finalIndex =
        random.nextInt(widget.usersName.length); // Randomly chosen box

    // Animation loop
    for (int i = 0; i <= cycles + finalIndex; i++) {
      highlightedIndex.value = i % widget.usersName.length;
      await Future.delayed(
          Duration(milliseconds: 80 + (i * 10))); // Gradually slow down
    }

    animationInProgress.value = false;
    selectedUser = widget.usersName[finalIndex];
    stopStartingSoundAndNavigate();
    startUserSelectionSound();

    // Display winner announcement dialog
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
              Text(
                "${selectedUser['userName']} Wins!",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Navigate after dialog dismissal (optional)
    Future.delayed(const Duration(seconds: 5), () {
      stopUserSelectionSound();

      Get.back(); // Close the dialog
      Get.offAll(() => SplashPage(uaerscase: selectedUser));
    });
  }

  @override
  void dispose() {
    userSelectionSound.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.usersName.reversed;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: widget.usersName.length,
                itemBuilder: (context, index) {
                  String caseImage = widget.usersName[index]['caseImage']!;
                  // String userName = widget.usersName[index]['userName']!;

                  return Obx(
                    () => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: highlightedIndex.value == index
                              ? Colors.white
                              : Colors.transparent,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              caseImage,
                              fit: BoxFit.contain,
                            ),
                            // if (highlightedIndex.value == index)
                            //   Text(
                            //     userName,
                            //     style: const TextStyle(
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 16,
                            //       color: Colors.black,
                            //     ),
                            //     textAlign: TextAlign.center,
                            //   ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => InkWell(
                onTap:
                    animationInProgress.value ? null : startSelectionAnimation,
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
                      "Chose Player",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // ElevatedButton(
              //   onPressed:
              //      ,
              //   child: const Text(
              //     "Choose Player",
              //     style: TextStyle(fontSize: 18),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
