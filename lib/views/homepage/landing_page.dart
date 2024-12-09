import "package:desapv3/controllers/navigation_link.dart";
import "package:desapv3/services/firebase_auth_service.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
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

              if (_firebaseAuth.currentUser == null) {
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, loginRoute, (Route route) => route.isFirst);
                }
              } else {
                toastErrorPopUp(
                    "We have encountered an issue when logout, please try again.");
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                child: const Text("To QR"),
                onPressed: () {
                  Navigator.pushNamed(context, qrCodeScannerRoute);
                }),
            ElevatedButton(
                child: const Text("To QR Gen"),
                onPressed: () {
                  Navigator.pushNamed(context, qrCodeGeneratorRoute);
                }),
            ElevatedButton(
                child: const Text("To HomeSent"),
                onPressed: () {
                  Navigator.pushNamed(context, homeSentinelRoute);
                }),
          ],
        ),
      ),
    );
  }

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
