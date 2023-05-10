import 'loan_item.dart';

class Loan {
  Loan({
    this.id,
    required this.delivered,
    required this.loaner,
    required this.employee,
    required this.studyNumber,
    required this.comments,
    required this.loanDate,
    required this.returnDate,
    required this.items,
  }) {
    id ??= DateTime.now().millisecondsSinceEpoch.toString();
  }
  String? id;
  final String loaner;
  final String employee;
  final String studyNumber;
  final String comments;
  final DateTime loanDate;
  final DateTime returnDate;
  final List<LoanItem> items;
  bool delivered;

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json["id"],
        loaner: json["loaner"],
        employee: json["employee"],
        studyNumber: json["studyNumber"],
        comments: json["comments"],
        loanDate: DateTime.parse(json["loanDate"]),
        returnDate: DateTime.parse(json["returnDate"]),
        items:
            List<LoanItem>.from(json["items"].map((x) => LoanItem.fromJson(x))),
        delivered: json["delivered"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "loaner": loaner,
        "employee": employee,
        "studyNumber": studyNumber,
        "comments": comments,
        "loanDate": loanDate.toIso8601String(),
        "returnDate": returnDate.toIso8601String(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "delivered": delivered,
      };
}
