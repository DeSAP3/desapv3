import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  Future<void>? signUp(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errMsg = '';
      if (e.code == 'weak-password') {
        errMsg = 'Password';
      } else if (e.code == 'email-already-in-use') {
        errMsg = 'An account with that email has already existed/registered';
      }

      toastPopUp(errMsg);

    } catch (e) {
        toastPopUp("Unexpected error occured");
    }
  }
}

void toastPopUp(String eMsg) {
  Fluttertoast.showToast(
      msg: eMsg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM_RIGHT,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 12.0
      );
}
