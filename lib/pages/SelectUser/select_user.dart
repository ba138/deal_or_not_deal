import 'package:deal_or_not_deal/pages/splash_page/splash_page.dart';
import 'package:deal_or_not_deal/utills/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectUser extends StatefulWidget {
  final List<String> usersName;

  const SelectUser({
    super.key,
    required this.usersName,
  });

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  final RxInt revealedIndex = (-1).obs; // Tracks the currently revealed index
  RxMap<String, dynamic> assignedUsers =
      <String, dynamic>{}.obs; // Tracks assigned usernames and case images
  bool usernameRevealed = false; // Locks interaction after username is revealed
  List<String> caseDynamic = [];

  @override
  void initState() {
    widget.usersName.shuffle(); // Shuffle usernames for randomness
    caseDynamic = cases;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Container(
            height: MediaQuery.sizeOf(context).height / 0.9,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Colors.grey.shade700.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white,
                width: 2,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: caseDynamic.length,
                        itemBuilder: (context, index) {
                          String caseImage = caseDynamic[index];

                          return GestureDetector(
                            onTap: () {
                              // Lock further interaction once a username is revealed
                              if (!usernameRevealed) {
                                if (!assignedUsers
                                        .containsKey(widget.usersName.first) &&
                                    widget.usersName.isNotEmpty) {
                                  String selectedUsername =
                                      widget.usersName.removeAt(0);
                                  // Store the username and associated caseImage
                                  assignedUsers.value = {
                                    'caseImage': caseImage,
                                    "userName": selectedUsername,
                                  };
                                }
                                revealedIndex.value = index;
                                setState(() {
                                  usernameRevealed = true; // Lock further taps
                                });

                                // Show the dialog with username
                                Get.dialog(
                                  Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      height: 500,
                                      width: 500,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage("images/caseopen.png"),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          assignedUsers['userName'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  barrierDismissible: false,
                                );
                                Future.delayed(const Duration(seconds: 7), () {
                                  Get.back();
                                  Get.offAll(
                                    () => SplashPage(
                                      uaerscase: assignedUsers,
                                    ),
                                  );
                                });
                              }
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (revealedIndex.value != index &&
                                        caseImage.isNotEmpty)
                                      Image.asset(
                                        caseImage,
                                        fit: BoxFit.contain,
                                      ),
                                    if (revealedIndex.value == index &&
                                        assignedUsers.isNotEmpty)
                                      Text(
                                        assignedUsers.keys.first,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.transparent,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
