import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/widgets/loans_table.dart';

import 'add_loan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<Map<String, dynamic>> data = [];
              try {
                List<dynamic> json = jsonDecode(snapshot.data);
                for (var element in json) {
                  data.add(element);
                }
              } catch (e) {
                data = [];
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: LayoutBuilder(builder: (context, constraints) {
                  //     List<DataColumn> columns = [
                  //       const DataColumn(label: Text("Loaner")),
                  //       const DataColumn(label: Text("Study nr.")),
                  //       const DataColumn(label: Text("Employee")),
                  //       const DataColumn(label: Text("Loan Date")),
                  //       const DataColumn(label: Text("Return Date")),
                  //       const DataColumn(label: Text("Comments")),
                  //     ];
                  //     List<DataRow> rows = loans
                  //         .map<DataRow>(
                  //           (e) => DataRow(
                  //             color: e.returnDate.compareTo(DateTime.now()) < 0
                  //                 ? MaterialStateProperty.all(Colors.red)
                  //                 : null,
                  //             onSelectChanged: (selected) =>
                  //                 onRowPressed(selected, e),
                  //             cells: [
                  //               DataCell(SizedBox(
                  //                   width: constraints.maxWidth * 0.1,
                  //                   child: Text(e.loaner))),
                  //               DataCell(SizedBox(
                  //                   width: constraints.maxWidth * 0.08,
                  //                   child: Text(e.studyNumber))),
                  //               DataCell(SizedBox(
                  //                   width: constraints.maxWidth * 0.1,
                  //                   child: Text(e.employee))),
                  //               DataCell(SizedBox(
                  //                 width: constraints.maxWidth * 0.05,
                  //                 child: Text(
                  //                     "${e.loanDate.day}/${e.loanDate.month}-${e.loanDate.year}"),
                  //               )),
                  //               DataCell(SizedBox(
                  //                 width: constraints.maxWidth * 0.05,
                  //                 child: Text(
                  //                     "${e.returnDate.day}/${e.returnDate.month}-${e.returnDate.year}"),
                  //               )),
                  //               DataCell(SizedBox(
                  //                   width: constraints.maxWidth * 0.2,
                  //                   child: Text(e.comments))),
                  //             ],
                  //           ),
                  //         )
                  //         .toList();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                          vertical: constraints.maxHeight * 0.05),
                      child: LoansTableWidget(
                        loans: data,
                        onLoanAdded: () => setState(() {}),
                      ),
                      // child: DataTable(
                      //   columns: columns,
                      //   rows: rows,
                      //   dataRowHeight: 70,
                      //   showCheckboxColumn: false,
                      // ),
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
