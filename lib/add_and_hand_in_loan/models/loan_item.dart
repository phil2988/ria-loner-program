import 'package:ria_udlaans_program/loan_category.dart';

class LoanItem {
  LoanCategory? category;
  String? name;

  LoanItem({this.category, this.name});

  factory LoanItem.fromJson(Map<String, dynamic> json) => LoanItem(
        category: json["category"] == null
            ? null
            : LoanCategory.values
                .where((element) => element.toString() == json["category"])
                .first,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "category": category?.toString(),
        "name": name,
      };
}
