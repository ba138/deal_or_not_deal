import 'package:deal_or_not_deal/pages/SelectUser/select_user.dart';
import 'package:deal_or_not_deal/utills/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:get/get.dart';

class InputForum extends StatefulWidget {
  const InputForum({super.key});

  @override
  _InputForumState createState() => _InputForumState();
}

class _InputForumState extends State<InputForum> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> players =
      []; // List to store user and case info
  List<String> cases = List.generate(
      26, (index) => "images/Case ${index + 1}.png"); // Global case images list
  int i = 1;

  void addPlayer(String controller) {
    if (controller.isNotEmpty) {
      String playerName = controller.trim();
      if (cases.isNotEmpty) {
        cases.shuffle();
        String assignedCase = cases.removeAt(0);
        // Add player to the list
        setState(() {
          players.add(
              {'userName': playerName, 'caseImage': assignedCase, 'count': i});
        });
        debugPrint("this is the count$i");
        i++;
        // Show pop-up with assigned case
        Get.dialog(
          barrierColor: Colors.black,
          Dialog(
            backgroundColor: Colors.black,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Image.asset(
                    assignedCase,
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    "Is assigned to $playerName",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
            stopStartingSoundAndNavigate();
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
    try {
      // Stop the playback
      await soloud.stop(soundHandle);

      // Deinitialize the audio engine
      await soloud.disposeSource(source);
    } catch (e) {
      print("Error stopping or disposing audio: $e");
    }
  }

  @override
  void initState() {
    playStartingSound();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/inputpic.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (cases.isNotEmpty) ...[
                  SizedBox(
                    height: 400,
                    width: 400,
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
                            onSubmitted: (value) {
                              // Trigger the case assignment when Enter is pressed
                              if (value.isNotEmpty) {
                                addPlayer(value);
                              }
                            },
                          ),
                          const SizedBox(height: 60),
                          InkWell(
                            onTap: () {
                              // Trigger the case assignment on button tap
                              if (_controller.text.isNotEmpty) {
                                addPlayer(_controller.text);
                              }
                            },
                            child: Container(
                              height: 56,
                              width: 120,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.secondPrimaryColor,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
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
      ),
    );
  }
}
