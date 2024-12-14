// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:deal_or_not_deal/pages/MainPage/main_page.dart';
import 'package:deal_or_not_deal/utills/colors.dart';

class SplashPage extends StatelessWidget {
  Map<String, dynamic> uaerscase;
  SplashPage({
    super.key,
    required this.uaerscase,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          Get.offAll(
            () =>
                // Reset Game State
                MainPage(
              selectedUserData: uaerscase,
            ),
          );
          Get.deleteAll(force: true);
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
          image: DecorationImage(
            image: AssetImage("images/splash_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
