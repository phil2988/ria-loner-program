import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/loan_repository.dart';
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
          future: LoanRepository().getAllLoans(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading data"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data?.isNotEmpty == true) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: LayoutBuilder(builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth * 0.05;
                  final verticalPadding = constraints.maxHeight * 0.05;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      child: LoansTableWidget(
                        maxWidth: constraints.maxWidth - horizontalPadding * 2,
                        loans: snapshot.data ?? [],
                        onLoanAdded: () => setState(() {}),
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
