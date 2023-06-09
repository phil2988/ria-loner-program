import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/loan.dart';

class HandInItemDialog extends StatelessWidget {
  const HandInItemDialog({required this.item});

  final Loan item;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Hand in item",
        style: TextStyle(fontSize: 30),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.3,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Are you sure you want to hand in the following items?",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              ...item.items.map((e) => Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.45,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description: ${e.name ?? "n/a"}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth * 0.45,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Category: ${e.category?.toString() ?? "n/a"}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider()
                    ],
                  )),
            ],
          );
        }),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.all(20),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const SizedBox(
            height: 50,
            width: 150,
            child: Center(child: Text("Cancel")),
          ),
        ),
        ElevatedButton(
          onPressed: () => confirmHandIn(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const SizedBox(
            height: 50,
            width: 150,
            child: Center(child: Text("Confirm hand in")),
          ),
        ),
      ],
    );
  }

  void confirmHandIn(BuildContext context) {
    final dataFile = File("data.json");
    final data = dataFile.readAsStringSync();
    List<Loan> loans =
        jsonDecode(data).map<Loan>((e) => Loan.fromJson(e)).toList();
    try {
      loans.where((i) => i.id == item.id).first.delivered = true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error: Could not find item in list of loans."),
      ));
      Navigator.of(context).pop();
      return;
    }

    dataFile.writeAsStringSync(jsonEncode(loans));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Successfully registered hand in of item."),
    ));
    Navigator.of(context).pop();
  }
}
