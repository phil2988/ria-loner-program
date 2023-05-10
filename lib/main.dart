import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ria_udlaans_program/loan_item.dart';

import 'add_loan_screen.dart';
import 'loan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void addNewLoan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddLoanScreen()),
    ).then((value) => setState(() {}));
  }

  Future loadJsonString() async {
    File file;
    try {
      file = File("data.json");
      return await file.readAsString();
    } catch (e) {
      file = await File("data.json").create();
    }
    return await file.readAsString();
  }

  @override
  Widget build(BuildContext context) {
    onRowPressed(bool? selected, Loan item) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Hand in item", style: TextStyle(fontSize: 30)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Description: ${e.name ?? "n/a"}",
                                          style: const TextStyle(fontSize: 20)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * 0.45,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Category: ${e.category?.toString() ?? "n/a"}",
                                          style: const TextStyle(fontSize: 20)),
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
                    textStyle: const TextStyle(fontSize: 20)),
                child: const SizedBox(
                    height: 50,
                    width: 150,
                    child: Center(child: Text("Cancel"))),
              ),
              ElevatedButton(
                onPressed: () {
                  final dataFile = File("data.json");
                  final data = dataFile.readAsStringSync();
                  List<Loan> loans = jsonDecode(data)
                      .map<Loan>((e) => Loan.fromJson(e))
                      .toList();
                  try {
                    loans.where((i) => i.id == item.id).first.delivered = true;
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Error: Could not find item in list of loans.")));
                    Navigator.of(context).pop();
                    return;
                  }

                  dataFile.writeAsStringSync(jsonEncode(loans));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("Successfully registered hand in of item.")));
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 20)),
                child: const SizedBox(
                    height: 50,
                    width: 150,
                    child: Center(child: Text("Confirm hand in"))),
              ),
            ],
          );
        },
      ).then((value) => {setState(() {})});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('RIA Udlåns program'),
      ),
      body: FutureBuilder(
          future: loadJsonString(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading data"),
              );
            } else if (snapshot.hasData) {
              var data;
              try {
                data = jsonDecode(snapshot.data);
              } catch (e) {
                data = {};
              }
              List<Loan> loans = data.length > 0
                  ? data.map<Loan>((e) => Loan.fromJson(e)).toList()
                  : [];
              loans =
                  loans.where((element) => element.delivered == false).toList();
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: LayoutBuilder(builder: (context, constraints) {
                  List<DataColumn> columns = [
                    const DataColumn(label: Text("Loaner")),
                    const DataColumn(label: Text("Study nr.")),
                    const DataColumn(label: Text("Employee")),
                    const DataColumn(label: Text("Loan Date")),
                    const DataColumn(label: Text("Return Date")),
                    const DataColumn(label: Text("Comments")),
                  ];
                  List<DataRow> rows = loans
                      .map<DataRow>(
                        (e) => DataRow(
                          color: e.returnDate.compareTo(DateTime.now()) < 0
                              ? MaterialStateProperty.all(Colors.red)
                              : null,
                          onSelectChanged: (selected) =>
                              onRowPressed(selected, e),
                          cells: [
                            DataCell(SizedBox(
                                width: constraints.maxWidth * 0.1,
                                child: Text(e.loaner))),
                            DataCell(SizedBox(
                                width: constraints.maxWidth * 0.08,
                                child: Text(e.studyNumber))),
                            DataCell(SizedBox(
                                width: constraints.maxWidth * 0.1,
                                child: Text(e.employee))),
                            DataCell(SizedBox(
                              width: constraints.maxWidth * 0.05,
                              child: Text(
                                  "${e.loanDate.day}/${e.loanDate.month}-${e.loanDate.year}"),
                            )),
                            DataCell(SizedBox(
                              width: constraints.maxWidth * 0.05,
                              child: Text(
                                  "${e.returnDate.day}/${e.returnDate.month}-${e.returnDate.year}"),
                            )),
                            DataCell(SizedBox(
                                width: constraints.maxWidth * 0.2,
                                child: Text(e.comments))),
                          ],
                        ),
                      )
                      .toList();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                          vertical: constraints.maxHeight * 0.05),
                      child: DataTable(
                        columns: columns,
                        rows: rows,
                        dataRowHeight: 70,
                        showCheckboxColumn: false,
                      ),
                    ),
                  );
                }),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewLoan,
        tooltip: 'New loan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
