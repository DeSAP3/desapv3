import "package:desapv3/viewmodels/navigation_link.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:logger/logger.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final logger = Logger();

  int currActiveStep = 0;
  bool isCompleted = false;
  bool get isFirstStep => currActiveStep == 0;
  bool get isLastStep => currActiveStep == steps().length - 1;

  final formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final dBase = FirebaseFirestore.instance;

  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final staffId = TextEditingController();
  final fName = TextEditingController();
  final lName = TextEditingController();
  final address = TextEditingController();
  final profilePic = TextEditingController();

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Registration"),
        ),
        body: Center(
          child: Form(
            key: formKey,
            child: Stepper(
              type: StepperType.vertical,
              currentStep: currActiveStep,
              steps: steps(),
              onStepContinue: () {
                if (isLastStep) {
                  logger.d(
                      "In Firebase Query${steps().length - 1 + currActiveStep}");

                  if (formKey.currentState!.validate()) {
                    logger.d("In Firebase Auth");
                    _firebaseAuth
                        .createUserWithEmailAndPassword(
                            email: email.text, password: password.text)
                        .then((value) {
                      final User? user = _firebaseAuth.currentUser;
                      final userInfo = <String, String>{
                        "email": email.text,
                        "password": password.text,
                        "staffID": staffId.text,
                        "fName": fName.text,
                        "lName": lName.text,
                        "address": address.text,
                        // "profilePic": ""
                      };

                      dBase
                          .collection("User")
                          .doc(user?.uid)
                          .set(userInfo)
                          .onError((error, stackrace) {
                        logger.e("Error ${error.toString()}");
                      });
                    }).then((value) {
                      if (context.mounted) {
                        Navigator.pushNamed(context, authRoute);
                      }
                    }).onError((error, stackTrace) {
                      logger.e("Error ${error.toString()}");
                    });
                  }
                } else {
                  setState(() {
                    currActiveStep += 1;
                  });
                }
              },
              onStepCancel: () {
                //just go back to login page
                isFirstStep
                    ? Navigator.pop(context)
                    : setState(() {
                        currActiveStep -= 1;
                      }); //step backing
              },
              onStepTapped: (int index) {
                setState(() {
                  currActiveStep = index;
                });
              },
              controlsBuilder: (context, details) => Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(isLastStep ? 'Proceed' : 'Next'),
                      )),
                      if (!isFirstStep) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Back')),
                        )
                      ]
                    ],
                  )),
            ),
          ),
        ));
  }

  List<Step> steps() => [
        //Step 1
        Step(
          title: const Flexible(child: Text('Account Information')),
          isActive: currActiveStep >= 0,
          content: Column(children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  toastErrorPopUp("Email Address is required");
                  return "Please enter your email address.";
                }
                return null;
              },
              controller: email,
              decoration: const InputDecoration(
                  hintText: "Email Address",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              obscuringCharacter: '*',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  toastErrorPopUp("Password is required");
                  return "Please enter your password.";
                }
                return null;
              },
              controller: password,
              decoration: const InputDecoration(
                  hintText: "Password",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              obscuringCharacter: '*',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please reenter your password.";
                } else if (value != password.text) {
                  toastErrorPopUp(
                      "Confirm password is not the same as the password initially entered");
                  return "Confirm Password does not match with password";
                }
                return null;
              },
              controller: confirmPassword,
              decoration: const InputDecoration(
                  hintText: "Confirm Password",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: staffId,
              decoration: const InputDecoration(
                  hintText: "Staff ID (Optional)",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0))),
            ),
          ]),
        ),
        //Step 2
        Step(
          title: const Text('Personal Information'),
          isActive: currActiveStep >= 1,
          content: Column(children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  toastErrorPopUp("First name is required");
                  return "Please enter your first name.";
                }
                return null;
              },
              controller: fName,
              decoration: const InputDecoration(
                  hintText: "First Name",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  toastErrorPopUp("Last name is required");
                  return "Please enter your last name.";
                }

                return null;
              },
              controller: lName,
              decoration: const InputDecoration(
                  hintText: "Last Name",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0))),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  toastErrorPopUp("Address is required");
                  return "Please enter your address.";
                }
                return null;
              },
              controller: address,
              maxLines: 10,
              decoration: const InputDecoration(
                  hintText: "Address",
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0))),
            ),
          ]),
        ),
      ];

  void toastErrorPopUp(String eMsg) {
    Fluttertoast.showToast(
        msg: eMsg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM_RIGHT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
        timeInSecForIosWeb: 2);
  }
}
