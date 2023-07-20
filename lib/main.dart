import 'package:flutter/material.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/screens/home_screen.dart';
import 'package:sql_conn/sql_conn.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: dbConnect(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error SQL connection"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return const HomeScreen();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Future dbConnect() async {
    const ip = String.fromEnvironment("SQL_HOST_NAME", defaultValue: "");
    const port = String.fromEnvironment("SQL_PORT", defaultValue: "");
    const databaseName =
        String.fromEnvironment("SQL_DATABASE_NAME", defaultValue: "");
    const username = String.fromEnvironment("SQL_USER_NAME", defaultValue: "");
    const password = String.fromEnvironment("SQL_PASSWORD", defaultValue: "");

    if (ip.isEmpty ||
        port.isEmpty ||
        databaseName.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      throw Exception(
          "Did not find the nessasary information to connect to the database");
    }
    try {
      await SqlConn.connect(
        ip: ip,
        port: port,
        databaseName: databaseName,
        username: username,
        password: password,
      );

      if (SqlConn.isConnected) {
        print("Connected to database");
      } else {
        throw Exception("Could not connect to database");
      }
    } catch (e) {
      print(e);
      throw Exception("Could not connect to database");
    }
  }
}
