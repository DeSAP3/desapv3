import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class FirebaseAuthService {
  final logger = Logger();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        // Save user role in Firestore
        await _firestore.collection('User').doc(user.uid).set({
          'email': email,
          'role': role,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        toastErrorPopUp("Email entered already registered in system");
      } else {
        logger.e('Sign Up Error: $e');
        return null;
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      logger.d('Signing in');
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        toastErrorPopUp(
            "User with the email address entered not found in system's database");
      } else if (e.code == 'wrong-password') {
        toastErrorPopUp("Wrong password");
      }
    } catch (e) {
      logger.e('Sign Up Error: $e');
      return null;
    }

    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      logger.e("Failed to send password reset email: ${e.message}");
    }
  }

    // Stream for checking authentication status
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

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
