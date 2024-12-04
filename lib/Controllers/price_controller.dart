import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class PriceController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playMusic(String assetPath) async {
    try {
      await audioPlayer.play(DeviceFileSource(assetPath));
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
