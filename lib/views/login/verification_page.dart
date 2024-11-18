import 'dart:async';

import 'package:desapv3/controllers/navigation_link.dart';
import 'package:desapv3/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationService = FirebaseAuthService();
  late Timer timer;
  
  @override
  void initState() {
    super.initState();
    _verificationService.sendVerificationEmail();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
        timer.cancel();
        Navigator.pushReplacementNamed(context, authRoute);
      }
    }); //Every 5 seconds, Firebase check user email verification status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("An email for verification"),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  _verificationService.sendVerificationEmail();
                },
                child: const Text("Resend Email"))
          ],
        ),
      )),
    );
  }
}
