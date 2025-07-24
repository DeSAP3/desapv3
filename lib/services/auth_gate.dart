import 'package:desapv3/viewmodels/user_viewmodel.dart';
import 'package:desapv3/views/homepage/landing_page.dart';
import 'package:desapv3/views/login/login_page.dart';
import 'package:desapv3/views/login/verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Provider.of<UserViewModel>(context, listen: false).fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: _firebaseAuth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                // print("From AuthGate: User ${user?.uid}");
                if (user != null) {
                  if (snapshot.data!.emailVerified == true) {
                    // print("From AuthGate: User not null");
                    return const Homepage();
                  }
                  return const VerificationPage();
                } else {
                  // print("From AuthGate: Back to Login");
                  return const LoginPage();
                }
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
