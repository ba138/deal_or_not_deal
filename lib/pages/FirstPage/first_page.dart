import 'package:deal_or_not_deal/Controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());
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
      ),
    );
  }
}
