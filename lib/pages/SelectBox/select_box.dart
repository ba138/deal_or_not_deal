import 'package:deal_or_not_deal/pages/splash_page/splash_page.dart';
import 'package:deal_or_not_deal/utills/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectBox extends StatelessWidget {
  final String userName;
  const SelectBox({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.12,
                  // Use Expanded to make GridView flexible
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 20, bottom: 40),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              // mainAxisExtent: 200,
                              // maxCrossAxisExtent:
                              //     200, // Max width for each grid item

                              crossAxisCount: 7,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20.0,
                              childAspectRatio: 1.38),
                      itemCount: cases.length,
                      itemBuilder: (context, index) {
                        String caseImage = cases[index];
                        return InkWell(
                          onTap: () {
                            selectBox(caseImage);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              child: Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
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
                                      height: 200,
                                      width: 200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectBox(String caseImage) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 500,
          width: 500,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(caseImage)),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 5), () {
      Get.back(); // Close the dialog

      Get.offAll(
        () => SplashPage(
          uaerscase: {"userName": userName, "caseImage": caseImage},
        ),
      );
      Get.deleteAll(force: true);
    });
  }
}
