import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthNotifier with ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  User? user;
  bool authStateCheck = false;

  //This viewmodel mainly notifies the system regarding the authentication status of the user 
  //in Firebase Authentication Feature
  AuthNotifier({required this.firebaseAuth}) {
    firebaseAuth.authStateChanges().listen((newUser) async {
      if (authStateCheck) {
        return;
      }

      if (newUser != null) {
        user = newUser;
        notifyListeners();
        return;
      }

      if (newUser == null) {
        user = null;
        notifyListeners();
        return;
      }
    });
  }
}
