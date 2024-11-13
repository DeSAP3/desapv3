import "package:desapv3/controllers/navigation_link.dart";
import "package:desapv3/services/firebase_auth_service.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:logger/logger.dart";

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final logoutService = FirebaseAuthService();

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              logger.d("Logging out");
              await logoutService.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
            child: const Text("Bye"),
            onPressed: () {
              Navigator.pushNamed(context, loginRoute);
            }),
      ),
    );
  }
}
