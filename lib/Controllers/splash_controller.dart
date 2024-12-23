import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:deal_or_not_deal/pages/SelectUser/input_form.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  late SoLoud soloud;
  late SoundHandle soundHandle;
  late AudioSource source;
  Future<void> playStartingSound() async {
    try {
      // Initialize the audio engine
      soloud = SoLoud.instance;
      await soloud.init();

      // Load the audio asset and play with looping
      source = await soloud.loadAsset('audio/starting_sound.mp3');
      soundHandle = await soloud.play(source, looping: true, volume: 1.0);
    } catch (e) {
      print("Error initializing or playing audio: $e");
    }
  }

  Future<void> stopStartingSoundAndNavigate() async {
    // try {
    //   // Stop the playback
    //   await soloud.stop(soundHandle);

    //   // Deinitialize the audio engine
    //   await soloud.disposeSource(source);
    // } catch (e) {
    //   print("Error stopping or disposing audio: $e");
    // }

    // Navigate to the next screen
    Get.offAll(() => const InputForum());
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   // playStartingSound();
  // }

  @override
  void dispose() {
    // Ensure resources are cleaned up
    soloud.deinit();
    super.dispose();
  }
}
