import '../loan_category.dart';

class LoanItem {
  String? id;
  LoanCategory? category;
  String? name;

  LoanItem({
    this.id,
    this.category,
    this.name,
  }) {
    id ??= DateTime.now().millisecondsSinceEpoch.toString();
  }

  factory LoanItem.fromJson(Map<String, dynamic> json) => LoanItem(
        id: json["id"].toString(),
        category: json["category"] == null
            ? null
            : LoanCategory.values
                .where((element) => element.toString() == json["category"])
                .first,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category?.toString(),
        "name": name,
      };
}
