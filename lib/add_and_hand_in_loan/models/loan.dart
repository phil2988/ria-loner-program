class Loan {
  Loan({
    this.id,
    required this.delivered,
    required this.loaner,
    required this.employee,
    required this.studyNumber,
    required this.comment,
    required this.loanDate,
    required this.returnDate,
  }) {
    id ??= DateTime.now().millisecondsSinceEpoch.toString();
  }
  String? id;
  final String loaner;
  final String employee;
  final String studyNumber;
  final String comment;
  final DateTime loanDate;
  final DateTime returnDate;
  bool delivered;

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json["id"].toString(),
        loaner: json["loaner"],
        employee: json["employee"],
        studyNumber: json["study_number"].toString(),
        comment: json["comment"],
        loanDate: DateTime.parse(json["loan_date"]),
        returnDate: DateTime.parse(json["return_date"]),
        delivered: json["delivered"] == "0" ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "loaner": loaner,
        "employee": employee,
        "studyNumber": studyNumber,
        "comments": comment,
        "loanDate": loanDate.toIso8601String(),
        "returnDate": returnDate.toIso8601String(),
        "delivered": delivered,
      };
}
