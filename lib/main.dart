import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ria_udlaans_program/add_and_hand_in_loan/screens/home_screen.dart';

import 'firebase_options.dart';

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
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.web,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error initializing Firebase"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              FirebaseFirestore.instance.settings = const Settings(
                persistenceEnabled: true,
                cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
              );

              return const HomeScreen();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
