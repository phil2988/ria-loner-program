import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'add_loan_screen.dart';

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
    final file = File("lib/data.json");
    return await file.readAsString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RIA Udlåns program'),
      ),
      body: FutureBuilder(
          future: loadJsonString(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data as String);
              List<DataColumn> columns = [
                const DataColumn(
                  label: Text("Loaner"),
                ),
                const DataColumn(label: Text("Study number")),
                const DataColumn(label: Text("Employee")),
                const DataColumn(label: Text("Comments")),
                const DataColumn(label: Text("Loan Date")),
                const DataColumn(
                  label: Text("Return Date"),
                ),
                const DataColumn(label: Text("Items")),
              ];

              List<DataRow> rows = data
                  .map<DataRow>(
                    (e) => DataRow(
                      color: DateTime.parse(e["returnDate"])
                                  .compareTo(DateTime.now()) <
                              0
                          ? MaterialStateProperty.all(Colors.red)
                          : null,
                      onSelectChanged: (value) {},
                      cells: [
                        DataCell(Text(e["loaner"])),
                        DataCell(Text(e["studyNumber"])),
                        DataCell(Text(e["employee"])),
                        DataCell(Text(e["comments"])),
                        DataCell(Text(
                            "${DateTime.parse(e["loanDate"]).day}/${DateTime.parse(e["loanDate"]).month}-${DateTime.parse(e["loanDate"]).year}")),
                        DataCell(Text(
                            "${DateTime.parse(e["returnDate"]).day}/${DateTime.parse(e["returnDate"]).month}-${DateTime.parse(e["returnDate"]).year}")),
                        DataCell(
                          Text((e["items"] as List<dynamic>)
                              .map((e) =>
                                  e["name"] +
                                  ": " +
                                  e["category"].toString().trim())
                              .toList()
                              .toString()
                              .replaceAll("[", "")
                              .replaceAll("]", "")
                              .replaceAll(", ", "\n")),
                        )
                      ],
                    ),
                  )
                  .toList();

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: LayoutBuilder(builder: (context, constraints) {
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
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
