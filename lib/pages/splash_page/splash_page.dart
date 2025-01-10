// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:deal_or_not_deal/Controllers/price_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:deal_or_not_deal/pages/MainPage/main_page.dart';
import 'package:deal_or_not_deal/utills/colors.dart';

class SplashPage extends StatelessWidget {
  final Map<String, dynamic> uaerscase;
  const SplashPage({
    super.key,
    required this.uaerscase,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          Get.deleteAll(force: true);

          Get.offAll(
            () =>
                // Reset Game State
                MainPage(
              selectedUserData: uaerscase,
            ),
          );
        },
        child: Container(
          height: 56,
          width: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondPrimaryColor],
              begin: Alignment.centerLeft, // Start from the left
              end: Alignment.centerRight, // End at the right
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              "Play",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0D12), // Near black
              Color(0xFF2A2B40), // Dark purple-gray
              Color(0xFF1F1F2E), // Deep slate blue
              Color(0xFF141414), // Pure black
            ],
            stops: [0.0, 0.4, 0.8, 1.0],
          ),
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage("images/logo.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
