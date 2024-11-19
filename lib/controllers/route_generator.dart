import "package:desapv3/controllers/navigation_link.dart";
import "package:desapv3/services/auth_gate.dart";
import "package:desapv3/views/homepage/landing_page.dart";
import "package:desapv3/views/login/forgotten_password_page.dart";
import "package:desapv3/views/login/login_page.dart";
import "package:desapv3/views/register/register_page.dart";
import "package:flutter/material.dart";

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(builder: (context) => const Homepage());

    case loginRoute:
      return MaterialPageRoute(builder: (context) => const LoginPage());

    case registerRoute:
      return MaterialPageRoute(builder: (context) => const RegisterPage());

    case authRoute:
      return MaterialPageRoute(builder: (context) => AuthGate());

    case forgottenpasswordRoute:
      return MaterialPageRoute(builder: (context) => const ForgottenPasswordPage());

    default:
      return MaterialPageRoute(builder: (context) => const ErrorPage());
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, homeRoute);
          },
          child: const Text("Back to Safety"),
        ),
      ),
    );
  }
}
