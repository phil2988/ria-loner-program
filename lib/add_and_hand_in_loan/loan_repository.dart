import 'package:ria_udlaans_program/add_and_hand_in_loan/models/loan.dart';

class LoanRepository {
  /// Adds a loan to the database
  ///
  /// [loan] is the loan to add
  Future addLoan(Loan loan) async {
    try {} catch (e) {
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
    try {} catch (e) {
      print(e);
      return [];
    }

    return [];
  }
}
