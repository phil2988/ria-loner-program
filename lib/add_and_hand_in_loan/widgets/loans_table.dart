import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../models/loan.dart';
import 'hand_in_item_dialog.dart';
import '../models/loan.dart';

class LoansTableWidget extends StatefulWidget {
  const LoansTableWidget(
      {Key? key, required this.loans, required this.onLoanAdded})
      : super(key: key);

  final List<Map<String, dynamic>> loans;
  final VoidCallback onLoanAdded;

  @override
  State<LoansTableWidget> createState() => _LoansTableWidgetState();
}

class _LoansTableWidgetState extends State<LoansTableWidget> {
  List<DataColumn> columns = [];
  List<DataRow> rows = [];

  void onRowPressed(bool? selected, Loan item) {
    showDialog(
      context: context,
      builder: (context) => HandInItemDialog(item: item),
    ).then((value) => widget.onLoanAdded());
  }

  @override
  void initState() {
    super.initState();

    columns = getColumnData(widget.loans);
    rows = getRowData(widget.loans);
  }

  List<DataColumn> getColumnData(List<Map<String, dynamic>> loans) {
    Set<String> columnNames = {};
    for (var loan in loans) {
      columnNames.addAll(loan.keys);
    }
    columnNames.remove('items');
    columnNames.remove('delivered');

    return columnNames
        .map((columnName) => DataColumn(label: Text(columnName)))
        .toList();
  }

  List<DataRow> getRowData(List<Map<String, dynamic>> loans) {
    return loans
        .where((loan) => loan['delivered'] == false)
        .map((loan) => DataRow(
              onSelectChanged: (value) =>
                  onRowPressed(value, Loan.fromJson(loan)),
              cells: getColumnData(loans).map((column) {
                final columnName = column.label as Text;
                if (isDateColumn(columnName.data.toString(), loan) &&
                    !loan["delivered"]) {
                  DateTime date =
                      DateTime.parse(loan[columnName.data.toString()]);
                  return DataCell(
                      Text("${date.day}/${date.month}-${date.year}"));
                } else {
                  return DataCell(
                      Text(loan[columnName.data.toString()]?.toString() ?? ''));
                }
              }).toList(),
            ))
        .toList();
  }

  bool isDateColumn(String columnName, Map<String, dynamic> loan) {
    return (columnName.contains('loanDate') && loan['loanDate'] != null) ||
        (columnName.contains('returnDate') && loan['returnDate'] != null);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(columns: columns, rows: rows);
  }
}
