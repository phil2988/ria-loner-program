import 'package:flutter/material.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/loan_repository.dart';

import '../models/loan.dart';
import '../models/loan_item.dart';
import '../widgets/loan_item_list_widget.dart';
import '../widgets/select_date_widget.dart';

class AddLoanScreen extends StatefulWidget {
  const AddLoanScreen({Key? key}) : super(key: key);

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
              return Column(
                children: [
                  buildFormFields(pageConstraints),
                  buildDateSelection(pageConstraints),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  LoanItemList(setLoanItems: setItems),
                ],
              );

              // return Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     SizedBox(
              //       width: pageConstraints.maxWidth * 0.6,
              //       child: Column(
              //         children: [
              //           buildFormFields(pageConstraints),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(width: 20),
              //     SizedBox(
              //       width: pageConstraints.maxWidth * 0.35,
              //       child: Column(
              //         mainAxisSize: MainAxisSize.max,
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           buildDateSelection(pageConstraints),
              //           const SizedBox(height: 20),
              //           const SizedBox(height: 10),
              //           LoanItemList(setLoanItems: setItems),
              //         ],
              //       ),
              //     ),
              //   ],
              // );
            }),
          ),
        ),
      ),
    );
  }

  Column buildFormFields(BoxConstraints constraints) {
    return Column(
      children: [
        buildFormField(
          constraints: constraints,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a loaner';
            }
            return null;
          },
          controller: loanerController,
          hintText: 'Loaner',
        ),
        const SizedBox(height: 20),
        buildFormField(
          constraints: constraints,
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
          hintText: 'Study number',
        ),
        const SizedBox(height: 20),
        buildFormField(
          constraints: constraints,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an employee';
            }
            return null;
          },
          controller: employeeController,
          hintText: 'Employee',
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
  }

  TextFormField buildFormField({
    required BoxConstraints constraints,
    required String? Function(String?) validator,
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }

  Column buildDateSelection(BoxConstraints constraints) {
    return Column(
      children: [
        buildDateRow(
          constraints: constraints,
          labelText: 'Loan date:   ',
          label: 'Loan date',
          onDateSelected: (date) => setState(() {
            loanDate = date;
          }),
        ),
        buildDateRow(
          constraints: constraints,
          labelText: 'Return date:   ',
          label: 'Return date',
          onDateSelected: (date) => setState(() {
            returnDate = date;
          }),
        ),
      ],
    );
  }

  Row buildDateRow({
    required BoxConstraints constraints,
    required String labelText,
    required String label,
    required void Function(DateTime?) onDateSelected,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Text(labelText),
            SelectDateWidget(
              initialDate: DateTime.now(),
              lastDate: DateTime.now(),
              label: label,
              onDateSelected: onDateSelected,
            ),
          ],
        ),
      ],
    );
  }

  void setItems(List<LoanItem> items) {
    this.items = items;
  }

  void saveToJson() {
    // final file = File('data.json');
    // final existingData = file.readAsStringSync();
    // final existingDataDecoded =
    //     existingData.isNotEmpty ? jsonDecode(existingData) : [];

    // existingDataDecoded.add(
    //   Loan(
    //     loaner: loanerController.text,
    //     employee: employeeController.text,
    //     studyNumber: studyNumberController.text,
    //     comments: commentsController.text,
    //     loanDate: loanDate ?? DateTime.now(),
    //     returnDate: returnDate ?? DateTime.now(),
    //     items: items,
    //     delivered: false,
    //   ).toJson(),
    // );

    // file.writeAsStringSync(jsonEncode(existingDataDecoded));

    LoanRepository().addLoan(Loan(
      loaner: loanerController.text,
      employee: employeeController.text,
      studyNumber: studyNumberController.text,
      comment: commentsController.text,
      loanDate: loanDate ?? DateTime.now(),
      returnDate: returnDate ?? DateTime.now(),
      items: items,
      delivered: false,
    ));
  }
}
