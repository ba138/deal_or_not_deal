import 'package:deal_or_not_deal/pages/SelectBox/select_box.dart';
import 'package:deal_or_not_deal/utills/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
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
  late SoLoud soloud;
  late SoundHandle soundHandle;
  late AudioSource source;
  final RxInt highlightedIndex =
      (-1).obs; // Current highlighted box during animation
  final RxBool animationInProgress = false.obs; // Tracks animation state
  final Random random = Random();
  Map<String, dynamic> selectedUser = {}; // Holds the final selected user data

  Future<void> playStartingSound() async {
    soloud = SoLoud.instance;
    await soloud.init();

    source = await soloud.loadAsset('audio/starting_sound.mp3');
    soundHandle = await soloud.play(source, looping: true, volume: 1.0);
  }

  Future<void> startUserSelectionSound() async {
    soloud = SoLoud.instance;
    await soloud.init();

    source = await soloud.loadAsset('audio/player_selection_sound.mp3');
    soundHandle =
        await soloud.play(source, looping: true, volume: 1.0, pan: 0.0);
  }

  Future<void> stopUserSelectionSound() async {
    await soloud.stop(soundHandle);

    await soloud.disposeSource(source);
  }

  Future<void> startSelectionAnimation() async {
    if (animationInProgress.value) return;
    await playStartingSound();
    animationInProgress.value = true;
    int cycles = 20;
    int finalIndex = random.nextInt(widget.usersName.length);

    for (int i = 0; i <= cycles + finalIndex; i++) {
      highlightedIndex.value = i % widget.usersName.length;
      await Future.delayed(Duration(milliseconds: 90 + (i * 10)));
    }

    animationInProgress.value = false;
    selectedUser = widget.usersName[finalIndex];

    // stopUserSelectionSound();
    await startUserSelectionSound();

    Get.dialog(
      barrierColor: Colors.black,
      Dialog(
        backgroundColor: Colors.black,
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
                "${selectedUser['userName']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "Wins!",
                style: TextStyle(
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

    Future.delayed(const Duration(seconds: 5), () async {
      await stopUserSelectionSound();
      Get.back(); // Close the dialog

      Get.offAll(() => SelectBox(
            userName: selectedUser['userName'],
          ));
      Get.deleteAll(force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/splash_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.35,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 1.56),
                  itemCount: widget.usersName.length,
                  itemBuilder: (context, index) {
                    String caseImage = widget.usersName[index]['caseImage']!;
                    widget.usersName
                        .sort((a, b) => a['count'].compareTo(b['count']));

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
                  onTap: animationInProgress.value
                      ? null
                      : startSelectionAnimation,
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
                        "Choose Player",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
