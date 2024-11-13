import 'package:desapv3/views/homepage/landing_page.dart';
import 'package:desapv3/views/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: _firebaseAuth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                if (user != null) {
                  return const Homepage();
                } else {
                  return const LoginPage();
                }
              } 
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
