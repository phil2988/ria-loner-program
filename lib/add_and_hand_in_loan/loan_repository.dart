import 'package:ria_udlaans_program/add_and_hand_in_loan/models/loan.dart';
import 'package:sql_conn/sql_conn.dart';

class LoanRepository {
  /// Adds a loan to the database
  ///
  /// [loan] is the loan to add
  Future addLoan(Loan loan) async {
    // Building query for adding loan to database
    String query = "INSERT INTO Loans VALUES (";
    query += "'${loan.id}',";
    query += "'${loan.loaner}',";
    query += "'${loan.studyNumber}',";
    query += "'${loan.comment}',";
    query +=
        "'${loan.loanDate.year}-${loan.loanDate.month < 10 ? "0${loan.loanDate.month}" : loan.loanDate.month}-${loan.loanDate.day < 10 ? "0${loan.loanDate.day}" : loan.loanDate.day}',";
    query +=
        "'${loan.returnDate.year}-${loan.returnDate.month < 10 ? "0${loan.returnDate.month}" : loan.returnDate.month}-${loan.returnDate.day < 10 ? "0${loan.returnDate.day}" : loan.returnDate.day}',";
    query += "'${loan.employee}')";

    // Writing query to database
    try {
      final res = await SqlConn.writeData(query);
      // Should return true if the query was successful
      if (res == false) {
        throw Exception("Adding loan to database returned false");
      }
    } catch (e) {
      throw Exception("Error adding loan to database");
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
