import 'package:deal_or_not_deal/pages/SelectUser/select_user.dart';
import 'package:deal_or_not_deal/pages/splash_page/splash_page.dart';
import 'package:deal_or_not_deal/utills/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputForum extends StatefulWidget {
  const InputForum({super.key});

  @override
  _InputForumState createState() => _InputForumState();
}

class _InputForumState extends State<InputForum> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> players =
      []; // List to store user and case info
  List<String> cases = List.generate(
      26, (index) => "images/Case ${index + 1}.png"); // Global case images list

  void addPlayer() {
    if (_controller.text.isNotEmpty) {
      String playerName = _controller.text.trim();
      if (cases.isNotEmpty) {
        String assignedCase = cases.removeAt(0);

        // Add player to the list
        setState(() {
          players.add({'userName': playerName, 'caseImage': assignedCase});
        });

        // Show pop-up with assigned case
        Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "$playerName is assign with",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    assignedCase,
                    height: 200,
                    width: 200,
                  )
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );

        // Close pop-up after delay
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
          if (players.length == 26) {
            Get.deleteAll(force: true);

            Get.offAll(() => SelectUser(
                  usersName: players,
                ));
          }
          _controller.clear();
        });
      } else {
        // Handle no more cases left
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No more cases available.")),
        );
      }
    } else {
      // Handle empty input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a player name.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (cases.isNotEmpty) ...[
                SizedBox(
                  height: 400,
                  width: 400,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: "Enter Player Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 60),
                          InkWell(
                            onTap: addPlayer,
                            // onTap: () {
                            //   Get.offAll(() => SplashPage(uaerscase: const {
                            //         'userName': "Basit Ali",
                            //         'caseImage':
                            //             "images/Flying Jets - 5,000.png"
                            //       }));
                            // },
                            child: Container(
                              height: 56,
                              width: 120,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.secondPrimaryColor
                                  ],
                                  begin: Alignment
                                      .centerLeft, // Start from the left
                                  end:
                                      Alignment.centerRight, // End at the right
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else
                const Text(
                  "All cases have been assigned.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
