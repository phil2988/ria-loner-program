import 'package:flutter/material.dart';

import '../models/loan.dart';
import 'hand_in_item_dialog.dart';

class LoansTableWidget extends StatefulWidget {
  const LoansTableWidget(
      {Key? key,
      required this.loans,
      required this.onLoanAdded,
      required this.maxWidth})
      : super(key: key);

  final List<Map<String, dynamic>> loans;
  final double maxWidth;
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
      columnNames.addAll(loan.keys.where((element) =>
          element == "loaner" ||
          element == "study_number" ||
          element == "return_date"));
    }

    return columnNames
        .map(
          (columnName) => DataColumn(
            label: Text(columnName),
          ),
        )
        .toList();
  }

  List<DataRow> getRowData(List<Map<String, dynamic>> loans) {
    return loans
        .where((loan) => loan['delivered'] == 0)
        .map(
          (loan) => DataRow(
            onSelectChanged: (value) => onRowPressed(
              value,
              Loan.fromJson(loan),
            ),
            cells: getColumnData(loans).map(
              (column) {
                final columnName = column.label as Text;
                if (isDateColumn(columnName.data.toString(), loan) &&
                    loan["delivered"] == 0) {
                  DateTime date = DateTime.parse(
                    loan[columnName.data.toString()],
                  );
                  return DataCell(
                    SizedBox(
                        width: widget.maxWidth / columns.length,
                        child: Text("${date.day}/${date.month}-${date.year}")),
                  );
                } else {
                  return DataCell(
                    SizedBox(
                        width: widget.maxWidth / columns.length,
                        child:
                            Text(loan[columnName.data.toString()].toString())),
                  );
                }
              },
            ).toList(),
          ),
        )
        .toList();
  }

  bool isDateColumn(String columnName, Map<String, dynamic> loan) {
    return (columnName.contains('loan_date') && loan['loan_date'] != null) ||
        (columnName.contains('return_date') && loan['return_date'] != null);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 0,
      columns: columns.map((column) {
        if ((column.label is Text) &&
            ((column.label as Text).data!.contains("_"))) {
          return DataColumn(
              label: Text((column.label as Text).data!.replaceAll("_", " ")));
        }
        return column;
      }).toList(),
      rows: rows,
      showCheckboxColumn: false,
    );
  }
}
