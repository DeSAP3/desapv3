import "package:desapv3/controllers/navigation_link.dart";
import "package:flutter/material.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Center(
        child: ElevatedButton(
            child: const Text("To Home Page"),
            onPressed: () {
              Navigator.pushNamed(context, homeRoute);
            }),
      ),
    );
  }
}
