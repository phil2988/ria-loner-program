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
        onPressed: () async {
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
            final snackbar = ScaffoldMessenger.of(context);
            final navigator = Navigator.of(context);

            if (!(await onSubmit())) {
              return;
            }
            snackbar.showSnackBar(
              const SnackBar(content: Text('Loan added!')),
            );
            navigator.pop();
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unexpected error occured...')),
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
                  const SizedBox(height: 10),
                  buildDateSelection(pageConstraints),
                  const SizedBox(height: 10),
                  LoanItemList(setLoanItems: setItems),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Column buildFormFields(BoxConstraints constraints) {
    return Column(
      children: [
        TextFormField(
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
          onChanged: (val) => validateStudent(),
          controller: studyNumberController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Student number",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an employee';
            }
            return null;
          },
          controller: employeeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Employee",
          ),
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

  Row buildDateSelection(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        Column(
          children: [
            Text(labelText),
            const SizedBox(height: 10),
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

  Future<bool> onSubmit() async {
    final snackbar = ScaffoldMessenger.of(context);

    try {
      final student = await validateStudent();
      loanerController.text = student["Name"];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error validating student number')),
      );
      return false;
    }

    try {
      final loan = Loan(
        loaner: loanerController.text,
        employee: employeeController.text,
        studyNumber: studyNumberController.text,
        comment: commentsController.text,
        loanDate: loanDate ?? DateTime.now(),
        returnDate: returnDate ?? DateTime.now(),
        delivered: false,
      );

      if (loan.id == null) {
        throw Exception("Loan id is null");
      }

      await LoanRepository().addLoan(loan);

      await LoanRepository().addLoanItems(
        loan.id!,
        items,
      );
    } catch (e) {
      snackbar.showSnackBar(
        SnackBar(content: Text('Error adding loan to database: $e')),
      );
      return false;
    }

    return true;
  }

  Future<Map<String, dynamic>> validateStudent() async {
    try {
      return await LoanRepository()
          .validateStudyNumber(studyNumberController.text);
    } catch (e) {
      throw Exception("Error validating student number");
    }
  }
}
