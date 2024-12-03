import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Card(
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  border: Border.all(
                      color: Colors.white,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignCenter),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Card(
                    child: Container(
                      height: 120,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "images/logo.jpg",
                            ),
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.75,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        border: Border.all(
                            color: Colors.white,
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignCenter),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Card(
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  border: Border.all(
                      color: Colors.white,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignCenter),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
