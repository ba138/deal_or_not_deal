import 'package:deal_or_not_deal/pages/MainPage/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () => Get.offAll(
          () => const MainPage(), // Replace with the desired screen widget
        ),
        child: Container(
          height: 56,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.amber.shade300,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: const Center(
            child: Text(
              "Play",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
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
