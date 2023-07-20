import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/loan_repository.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/models/loan_item.dart';

import '../models/loan.dart';

class HandInItemDialog extends StatefulWidget {
  const HandInItemDialog({super.key, required this.item});

  final Loan item;

  @override
  State<HandInItemDialog> createState() => _HandInItemDialogState();
}

class _HandInItemDialogState extends State<HandInItemDialog> {
  List<LoanItem> items = [];
  bool loadingItems = true;

  @override
  void initState() {
    super.initState();

    // Fetch items from database
    if (widget.item.id == null) {
      throw Exception("Item id is null");
    }

    LoanRepository().getAllLoanItems(widget.item.id!).then(
          (value) => {
            for (var item in value)
              {
                items.add(
                  LoanItem.fromJson(item),
                )
              },
            setState(() {
              loadingItems = false;
            })
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Hand in item",
        style: TextStyle(fontSize: 30),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.6,
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                    "This item was lent out by ${widget.item.employee}. to ${widget.item.loaner}."),
                SizedBox(
                  height: constraints.maxHeight * 0.03,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Are you sure ALL of the items below are present?",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                if (loadingItems)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                const Divider(
                  thickness: 2,
                  height: 20,
                ),
                ...items.map((e) => Column(
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
                                    "${e.category?.toString() ?? "n/a"}:",
                                    style: const TextStyle(fontSize: 16),
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
                                    e.name ?? "n/a",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                      ],
                    )),
                widget.item.comment == null
                    ? Container()
                    : Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Comment from employee:")),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(widget.item.comment ?? "n/a")),
                        ],
                      ),
              ],
            ),
          );
        }),
      ),
      actionsPadding: const EdgeInsets.all(20),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => confirmHandIn(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Confirm"),
            ),
          ],
        ),
      ],
    );
  }

  void confirmHandIn(BuildContext context) async {
    final snackbar = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    // Update loan in database
    try {
      await LoanRepository().handInLoan(widget.item.id!);
    } catch (e) {
      snackbar.showSnackBar(const SnackBar(
        content: Text("Error handing in loan."),
      ));
      return;
    }

    snackbar.showSnackBar(const SnackBar(
      content: Text("Successfully registered hand in of item."),
    ));
    navigator.pop();
  }
}
