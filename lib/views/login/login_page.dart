import "package:desapv3/viewmodels/navigation_link.dart";
import "package:desapv3/viewmodels/user_viewmodel.dart";
import "package:desapv3/reuseable_widget/text_field_widget.dart";
import "package:desapv3/services/firebase_auth_service.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:logger/logger.dart";
import "package:provider/provider.dart";

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

  bool isPasswordVisible = true;
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height / 2.7,
                    child: Image.asset("images/DeSAP_Logo.jpeg"),
                  ),
                  const SizedBox(height: 10),
                  Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFieldWidget(
                              textInputType: TextInputType.text,
                              hintText: "Email Address",
                              prefixIcon: const Icon(Icons.email_rounded),
                              controller: _email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email Is Required";
                                }
                                return null;
                              }),
                          const SizedBox(height: 5),
                          TextFieldWidget(
                              textInputType: TextInputType.text,
                              hintText: "Password",
                              prefixIcon: const Icon(Icons.password),
                              obscureText: isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password Is Required";
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  icon: isPasswordVisible
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility)),
                              controller: _password),
                          SizedBox(
                            width: 350,
                            height: 25,
                            child: Align(
                                alignment: Alignment.topRight,
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Forgot Password?',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                            context, forgottenpasswordRoute))
                                ]))),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  // fontStyle: FontStyle.normal
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  user = await loginService
                                      .signInWithEmailAndPassword(
                                          _email.text, _password.text);

                                  if (user != null && user!.emailVerified) {
                                    if (context.mounted) {
                                      await Provider.of<UserViewModel>(context,
                                              listen: false)
                                          .fetchCurrentUser();

                                      if (mounted && context.mounted) {
                                        logger.d("Successfully logged in");
                                        Navigator.pushReplacementNamed(
                                            context, homeRoute);
                                      }
                                    }
                                  }
                                } on Exception catch (e) {
                                  logger.e("Error signing in: $e");
                                } catch (e) {
                                  logger.e(e.toString());
                                }
                              },
                              child: const Text('Login'))
                        ],
                      )),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                          text: 'Register Here',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                Navigator.pushNamed(context, registerRoute))
                    ])),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
