import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class PriceController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  // Function to play music
  Future<void> playMusic(String assetPath) async {
    try {
      print('Playing music: $assetPath');

      await audioPlayer
          .play(AssetSource("audio/boxopen.mp3")); // Play the asset
      print('Playing music: $assetPath');
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose(); // Clean up resources
    super.onClose();
  }
}
