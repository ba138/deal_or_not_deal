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
            Container(
              height: 800,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  8,
                ),
                border: Border.all(
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "images/logo.jpg",
                          ),
                          fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 500,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: Border.all(
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 800,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  8,
                ),
                border: Border.all(
                  color: Colors.amber,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
