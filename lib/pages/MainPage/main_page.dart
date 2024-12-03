import 'dart:math';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> cases =
      List.generate(26, (index) => "images/Case ${index + 1}.png");
  List<Map<String, dynamic>> priceListOne = [
    {
      "image": "images/Rose - 1.png",
      "priceId": "1",
      "priceValue": "1",
      "priceName": "Rose",
    },
    {
      "image": "images/Finger Heart - 5.png",
      "priceId": "2",
      "priceValue": "5",
      "priceName": "Finger Heart",
    },
    {
      "image": "images/Tiny Diny - 10.png",
      "priceId": "3",
      "priceValue": "10",
      "priceName": "Tiny Diny",
    },
    {
      "image": "images/Doughnut - 30.png",
      "priceId": "4",
      "priceValue": "30",
      "priceName": "Doughnut",
    },
    {
      "image": "images/Hand Heart - 100.png",
      "priceId": "5",
      "priceValue": "100",
      "priceName": "Hand Heart",
    },
    {
      "image": "images/Sunglasses - 199.png",
      "priceId": "6",
      "priceValue": "199",
      "priceName": "Sunglasses",
    },
    {
      "image": "images/Corgi - 299.png",
      "priceId": "7",
      "priceValue": "299",
      "priceName": "Corgi",
    },
    {
      "image": "images/Money Gun - 500.png",
      "priceId": "8",
      "priceValue": "500",
      "priceName": "Money Gun",
    },
    {
      "image": "images/Swan - 699.png",
      "priceId": "9",
      "priceValue": "699",
      "priceName": "Swan",
    },
    {
      "image": "images/Galaxy - 1,000.png",
      "priceId": "10",
      "priceValue": "1000",
      "priceName": "Galaxy",
    },
    {
      "image": "images/Chasing The Dream - 1,500.png",
      "priceId": "11",
      "priceValue": "1500",
      "priceName": "Chasing The Dream",
    },
    {
      "image": "images/Whale Diving - 2,150.png",
      "priceId": "12",
      "priceValue": "2150",
      "priceName": "Whale Diving",
    },
    {
      "image": "images/Motorcycle - 2,988.png",
      "priceId": "13",
      "priceValue": "2988",
      "priceName": "MotorCycle",
    },
  ];
  List<Map<String, dynamic>> priceListTwo = [
    {
      "image": "images/Golden Party - 3,000.png",
      "priceId": "14",
      "priceValue": "3000",
      "priceName": "Golden Party",
    },
    {
      "image": "images/Flower Overflow - 4,000.png",
      "priceId": "15",
      "priceValue": "4000",
      "priceName": "Flower Overflow",
    },
    {
      "image": "images/Leon The Kitten - 4,888.png",
      "priceId": "16",
      "priceValue": "4888",
      "priceName": "Leon The Kitten",
    },
    {
      "image": "images/Flying Jets - 5,000.png",
      "priceId": "17",
      "priceValue": "5000",
      "priceName": "Flying Jets",
    },
    {
      "image": "images/Wolf - 5,500.png",
      "priceId": "18",
      "priceValue": "5500",
      "priceName": "Wolf",
    },
    {
      "image": "images/Lili The Leopard - 6,599.png",
      "priceId": "19",
      "priceValue": "6599",
      "priceName": "Lili The Leopard",
    },
    {
      "image": "images/Sports Car - 7,000.png",
      "priceId": "20",
      "priceValue": "7000",
      "priceName": "Sports Car",
    },
    {
      "image": "images/Interstellar - 10,000.png",
      "priceId": "21",
      "priceValue": "10000",
      "priceName": "Interstellar",
    },
    {
      "image": "images/Rosa Nebula - 15,000.png",
      "priceId": "22",
      "priceValue": "15000",
      "priceName": "Rosa Nebula",
    },
    {
      "image": "images/TikTok Shuttle - 20,000.png",
      "priceId": "23",
      "priceValue": "20000",
      "priceName": "TikTok Shuttle",
    },
    {
      "image": "images/Rose Carriage - 25,000.png",
      "priceId": "24",
      "priceValue": "25999",
      "priceName": "Adams Dream",
    },
    {
      "image": "images/Lion - 29,999.png",
      "priceId": "25",
      "priceValue": "29999",
      "priceName": "Lion",
    },
    {
      "image": "images/TikTok Universe - 44,999.png",
      "priceId": "26",
      "priceValue": "44999",
      "priceName": "TikTok Universe",
    },
  ];
  @override
  void initState() {
    super.initState();
    shuffleCases(); // Shuffle the cases when the widget initializes
  }

  void shuffleCases() {
    setState(() {
      cases.shuffle(Random());
    });
  }

  Widget buildPriceList(List<Map<String, dynamic>> priceList) {
    return ListView.builder(
      itemCount: priceList.length,
      itemBuilder: (context, index) {
        final item = priceList[index];
        return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 7.0, horizontal: 8), // Add spacing here
            child: Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    item['image'],
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "${item['priceValue']}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget buildRow(List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items
          .map(
            (image) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                child: buildPriceList(priceListOne),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Card(
                    child: Container(
                      height: 120,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/logo.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.75,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildRow(
                                cases.sublist(0, 7)), // First row (7 items)
                            buildRow(
                                cases.sublist(7, 13)), // Second row (6 items)
                            buildRow(
                                cases.sublist(13, 19)), // Third row (6 items)
                            buildRow(
                                cases.sublist(19, 26)), // Fourth row (7 items)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Card(
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                ),
                child: buildPriceList(priceListTwo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
