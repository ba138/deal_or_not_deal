import 'package:deal_or_not_deal/pages/SelectUser/select_user.dart';
import 'package:deal_or_not_deal/utills/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputForum extends StatefulWidget {
  const InputForum({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InputForumState createState() => _InputForumState();
}

class _InputForumState extends State<InputForum>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(26, (_) => TextEditingController());

  void randomlySelectUser() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      List<String> players = _controllers
          .map((c) => c.text)
          .where((name) => name.isNotEmpty)
          .toList();

      if (players.isNotEmpty) {
        Get.offAll(SelectUser(usersName: players));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please enter at least one player name")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Select User'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Four items per row
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 1.0,
                    childAspectRatio:
                        4, // Adjust this ratio to balance width and height
                  ),
                  itemCount: 26,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1}',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        return (value != null && value.trim().isEmpty)
                            ? 'Name cannot be empty'
                            : null;
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => randomlySelectUser(),
              child: Container(
                height: 56,
                width: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.secondPrimaryColor
                    ],
                    begin: Alignment.centerLeft, // Start from the left
                    end: Alignment.centerRight, // End at the right
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
