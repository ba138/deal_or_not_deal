import 'package:flutter/material.dart';

Widget buildPriceList(List<Map<String, dynamic>> priceList) {
  return ListView.builder(
    itemCount: priceList.length,
    itemBuilder: (context, index) {
      final item = priceList[index];
      return item['image'] == ""
          ? Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 7.0, horizontal: 8), // Add spacing here
              child: Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Image.asset(
                    //   item['image'],
                    //   width: 30,
                    //   height: 30,
                    //   fit: BoxFit.cover,
                    // ),
                    Text(
                      "${item['priceValue']}",
                      style: const TextStyle(
                        color: Colors.transparent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ))
          : Padding(
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
