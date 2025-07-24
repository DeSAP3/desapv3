import 'package:desapv3/reuseable_widget/text_field_widget.dart';
import 'package:desapv3/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';

class ForgottenPasswordPage extends StatefulWidget {
  const ForgottenPasswordPage({super.key});

  @override
  State<ForgottenPasswordPage> createState() => _ForgottenPasswordPageState();
}

class _ForgottenPasswordPageState extends State<ForgottenPasswordPage> {
  final forgotPasswordService = UserViewModel();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgotten Password")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Enter your email address to reset your account password"),
          const SizedBox(height: 10),
          TextFieldWidget(
            hintText: "Email Address",
            controller: _email,
            prefixIcon: const Icon(Icons.email_rounded),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                forgotPasswordService.resetPassword(_email.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Reset Email Link has been sent to your email.")));
                Navigator.pop(context);
              },
              child: const Text("Proceed"))
        ],
      )),
    );
  }
}
