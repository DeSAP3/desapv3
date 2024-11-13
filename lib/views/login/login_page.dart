import "package:desapv3/controllers/navigation_link.dart";
import "package:desapv3/reuseable_widget/text_field_widget.dart";
import "package:desapv3/services/firebase_auth_service.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:logger/logger.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  final loginService = FirebaseAuthService();
  User? user;

  final logger = Logger();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeArea(
                  child: SizedBox(
                      child: Column(
                children: [
                  SizedBox(
                    height: height / 2.7,
                    child: Image.asset(""),
                  ),
                  const SizedBox(height: 10),
                  Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFieldWidget(
                              textInputType: TextInputType.text,
                              hintText: "Email Address",
                              controller: _email),
                          const SizedBox(height: 20),
                          TextFieldWidget(
                              textInputType: TextInputType.text,
                              hintText: "Password",
                              obscureText: true,
                              controller: _password),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  user = await loginService
                                      .signInWithEmailAndPassword(
                                          _email.text, _password.text);

                                  if (user != null) {
                                    if (context.mounted) {
                                      logger.d("Successfully logged in");
                                      Navigator.pushNamed(context, homeRoute);
                                    }
                                  }
                                } on Exception catch (e) {
                                  logger.e("Error signing in: $e");
                                }
                              },
                              child: const Text('Login'))
                        ],
                      )),
                ],
              ))),
              ElevatedButton(
                  child: const Text("To Home Page"),
                  onPressed: () {
                    Navigator.pushNamed(context, homeRoute);
                  }),
              ElevatedButton(
                  child: const Text("To Register Page"),
                  onPressed: () {
                    Navigator.pushNamed(context, registerRoute);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
