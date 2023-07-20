import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/models/loan.dart';

class LoanRepository {
  /// Adds a loan to the database
  ///
  /// [loan] is the loan to add
  Future addLoan(Loan loan) async {
    try {
      final database = FirebaseFirestore.instance;

      final loansCollection = database.collection("loans");

      var doc = await loansCollection
          .add(loan.toJson())
          .then((value) => print(value.id))
          .catchError((error) => print("Failed to add loan: $error"));
      print("");
    } catch (e) {
      print(e);
    }
  }

  /// Updates an exitsing loan in the database to be handed in
  ///
  /// [loan] is the loan to hand in
  Future handInLoan(Loan loan) async {}

  /// Gets all loans from the database
  ///
  /// Returns an empty list if no loans are found
  Future<List<Map<String, dynamic>>> getAllLoans() async {
    try {
      final database = FirebaseFirestore.instance;

      final loansCollection = database.collection("loans").doc();
      List<Map<String, dynamic>> data = [];

      // data = await loansCollection;
      return data;
    } catch (e) {
      print(e);
      return [];
    }

    // final db = FirebaseFirestore.instance;
    // final loans = db.collection("loans").snapshots();
    // List<Map<String, dynamic>> data = [];

    // try {
    //   for (var loan in (await loans.first).docs) {
    //     data.add(loan.data());
    //   }
    // } catch (e) {
    //   print(e);
    // }
    // return [];
  }
}
