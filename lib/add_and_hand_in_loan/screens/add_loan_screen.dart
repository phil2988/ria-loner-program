import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../models/loan.dart';

class AddLoanScreen extends StatefulWidget {
  const AddLoanScreen({super.key});

  @override
  State<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends State<AddLoanScreen> {
  final _formKey = GlobalKey<FormState>();

  final loanerController = TextEditingController();
  final employeeController = TextEditingController();
  final studyNumberController = TextEditingController();
  final commentsController = TextEditingController();
  DateTime? loanDate;
  DateTime? returnDate;
  List<LoanItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (items.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No items selected')),
            );
            return;
          }
          if (loanDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No loan date selected')),
            );
            return;
          }
          if (returnDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No return date selected')),
            );
            return;
          }
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loan added!')),
            );
            saveToJson();
            Navigator.pop(context);
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error...')),
          );
        },
        child: const Icon(Icons.check),
      ),
      appBar: AppBar(
        title: const Text('Back to main screen'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: LayoutBuilder(builder: (context, pageConstraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: pageConstraints.maxWidth * 0.6,
                    child: Column(
                      children: [
                        LayoutBuilder(builder: (context, leftConstraints) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: leftConstraints.maxWidth * 0.45,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a loaner';
                                        }
                                        return null;
                                      },
                                      controller: loanerController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Loaner',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: leftConstraints.maxWidth * 0.45,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a value';
                                        }

                                        final numericRegex = RegExp(r'^\d+$');
                                        if (!numericRegex.hasMatch(value)) {
                                          return 'Input must contain only numbers';
                                        }

                                        if (value.length != 9) {
                                          return 'Input must have a length of exactly 9';
                                        }

                                        return null;
                                      },
                                      controller: studyNumberController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Study number',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: leftConstraints.maxWidth * 0.45,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter an employee';
                                        }
                                        return null;
                                      },
                                      controller: employeeController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Employee',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                maxLines: 5,
                                controller: commentsController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Comments',
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: pageConstraints.maxWidth * 0.35,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, rightConstraints) {
                            return SizedBox(
                              width: rightConstraints.maxWidth,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Loan date:   "),
                                          SelectDateWidget(
                                              initialDate: DateTime.now(),
                                              lastDate: DateTime.now(),
                                              label: "Loan date",
                                              onDateSelected: (date) =>
                                                  setState(() {
                                                    loanDate = date;
                                                  })),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Return date:   "),
                                          SelectDateWidget(
                                              lastDate: DateTime.now()
                                                  .add(const Duration(days: 3)),
                                              label: "Return date",
                                              onDateSelected: (date) =>
                                                  setState(() {
                                                    returnDate = date;
                                                  })),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const SizedBox(height: 10),
                                  LoanItemList(setLoanItems: (items) {
                                    this.items = items;
                                  }),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  saveToJson() {
    File file = File('data.json');
    var existingData = file.readAsStringSync();

    var existingDataDecoded =
        existingData.isNotEmpty ? jsonDecode(existingData) : [];

    existingDataDecoded.add(Loan(
      loaner: loanerController.text,
      employee: employeeController.text,
      studyNumber: studyNumberController.text,
      comments: commentsController.text,
      loanDate: loanDate ?? DateTime.now(),
      returnDate: returnDate ?? DateTime.now(),
      items: items,
      delivered: false,
    ).toJson());

    file.writeAsStringSync(jsonEncode(existingDataDecoded));
  }
}
