import 'dart:convert';

import 'package:ria_udlaans_program/add_and_hand_in_loan/models/loan.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/models/loan_item.dart';
import 'package:sql_conn/sql_conn.dart';

class LoanRepository {
  /// Adds a loan to the database
  ///
  /// [loan] is the loan to add
  Future addLoan(Loan loan) async {
    // Building query for adding loan to database
    String query = "INSERT INTO Loans VALUES (";
    query += "'${loan.id}'";
    query += ",'${loan.employee}'";
    query += ",'${loan.loaner}'";
    query += ",'${loan.studyNumber}'";
    query += ",'${loan.comment}'";
    query +=
        ",'${loan.loanDate.year}-${loan.loanDate.month < 10 ? "0${loan.loanDate.month}" : loan.loanDate.month}-${loan.loanDate.day < 10 ? "0${loan.loanDate.day}" : loan.loanDate.day}'";
    query +=
        ",'${loan.returnDate.year}-${loan.returnDate.month < 10 ? "0${loan.returnDate.month}" : loan.returnDate.month}-${loan.returnDate.day < 10 ? "0${loan.returnDate.day}" : loan.returnDate.day}'";
    query += ",'0'";
    query += ")";

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

  Future addLoanItems(String loanId, List<LoanItem> items) async {
    // Building query for adding loanitems to database
    String query = "INSERT INTO LoanItems VALUES ";

    for (var loanItem in items) {
      query += "('${loanItem.id}'";
      query += ",'${loanItem.category}'";
      query += ",'${loanItem.name}'";
      query += ",'$loanId'";
      if (loanItem == items.last) {
        query += ")";
      } else {
        query += "),";
      }
    }

    // Writing query to database
    try {
      final res = await SqlConn.writeData(query);
      // Should return true if the query was successful
      if (res == false) {
        throw Exception("Adding loan items to database returned false");
      }
    } catch (e) {
      throw Exception("Error adding loan items to database");
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
      // Getting all loans from database
      final jsonString = await SqlConn.readData("SELECT * FROM Loans");

      // Convert the data from a string to a list of dynamic maps
      final List<dynamic> dataList = jsonDecode(jsonString);

      // Convert the list of dynamic maps to a list of maps with String keys
      final List<Map<String, dynamic>> data =
          dataList.cast<Map<String, dynamic>>();

      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> validateStudyNumber(String studyNumber) async {
    try {
      final jsonString = await SqlConn.readData(
          "SELECT * FROM Members WHERE UniversityNumber = '$studyNumber'");

      // Convert the data from a string to a list of dynamic maps
      final List<dynamic> dataList = jsonDecode(jsonString);

      // Convert the list of dynamic maps to a list of maps with String keys
      final List<Map<String, dynamic>> data =
          dataList.cast<Map<String, dynamic>>();

      return data.first;
    } catch (e) {
      print(e);
      return {};
    }
  }
}
