import 'package:audioplayers/audioplayers.dart';
import 'package:deal_or_not_deal/pages/SelectUser/input_form.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  late AudioPlayer startingSound;
  Future<void> playStartingSound() async {
    startingSound = AudioPlayer();
    await startingSound.setReleaseMode(ReleaseMode.loop); // Loop the sound
    await startingSound.play(DeviceFileSource("audio/starting_sound.mp3"));

    // Stop the sound after 3 seconds
  }

  Future<void> stopStartingSoundAndNavigate() async {
    await startingSound.stop();

    Get.offAll(() => const InputForum());
  }

  @override
  void onInit() {
    playStartingSound();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    startingSound.dispose();
  }
}
