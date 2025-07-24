import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/user.dart';
import 'package:desapv3/reuseable_widget/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart' as userfb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class UserViewModel with ChangeNotifier {
  final List<User> _userList = [];

  bool _isFetchingUser = false; //Is an user fetching in progress?

  bool get isFetchingUser => _isFetchingUser; //Get the status of the fetching progress

  bool get isUserLoaded => _userList.isNotEmpty; //Is the list empty?

  List<User> get oviTrapList => _userList; //Return the user list

  User? _user;

  User? get user => _user;

  final userfb.FirebaseAuth _firebaseAuth = userfb.FirebaseAuth.instance;

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  userfb.User? currentUser;

  Logger logger = Logger();

  //Get the information of the current user from Firebase
  Future<void> fetchCurrentUser() async {
    _isFetchingUser = true;

    final doc = await FirebaseFirestore.instance
        .collection('User')
        .doc(currentUser!.uid)
        .get();

    _user = User.fromFirestore(doc);
    _isFetchingUser = false;
    notifyListeners();
  }

//Get the information of all user from Firebase
  Future<List<User>> fetchAllUser() async {
    try {
      _userList.clear();
      _isFetchingUser = true;

      QuerySnapshot querySnapshot = await dBaseRef.collection('User').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        User user = User(
            doc.id,
            data['email'] ?? '',
            data['fName'] ?? '',
            data['lName'] ?? '',
            data['staffID'] ?? '',
            data['address'] ?? '',
            data['role'] ?? 0);

        _userList.add(user);
        logger.d(user);
      }
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingUser = false;
      notifyListeners();
    }

    return _userList;
  }

  //Updates user information in Firebase
  Future<void> updateUser(User newUser, int index) async {
    try {
      await dBaseRef.collection('User').doc(newUser.userID).update({
        'fName': newUser.fName,
        'lName': newUser.lName,
        'staffID': newUser.staffID,
        'address': newUser.address,
        'role': assignRole(newUser.staffID!),
      });

      _userList.update(index, newUser);
      notifyListeners();
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

//Delete user information in Firebase
  Future<void> deleteUser(User delUser) async {
    await dBaseRef.collection('User').doc(delUser.userID).delete().then(
        (doc) => logger.d("User deleted"),
        onError: (e) => logger.e("Error deleting User document: $e"));

    _userList.remove(delUser);
    notifyListeners();
  }

  //Set the
  String getRole(int roleNum) {
    if (roleNum == 1) {
      return "Admin";
    } else if (roleNum == 2) {
      return "Entomologist";
    } else if (roleNum == 3) {
      return "Operation Member";
    } else {
      return "DC Reporter";
    }
  }

  //Set the role of the user account based on the staff ID prefix
  int assignRole(String staffID) {
    try {
      //The staffID is related to their position
      String staffIDPrefix = staffID.substring(0, 4);

      if (staffIDPrefix == "HOA") {
        return 1; //HOAdmin
      } else if (staffIDPrefix == "ENT") {
        return 2; //Entomologist
      } else if (staffIDPrefix == "OPT") {
        return 3; //OT
      } else {
        return 0; //DengueCaseReporter
      }
    } catch (e) {
      return 0; //In case of error, default to DengueCaseReporter
    }
  }

  //Handles account registration in Firebase
  Future<userfb.User?> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      userfb.UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      userfb.User? user = credential.user;

      if (user != null) {
        // Save user role in Firestore
        // Pass data to here to get data in Firebase
        await dBaseRef.collection('User').doc(user.uid).set({
          'email': email,
        });
      }

      return user;
    } on userfb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        toastErrorPopUp("Email entered already registered in system");
      } else {
        logger.e('Sign Up Error: $e');
        return null;
      }
    }
    return null;
  }

//Handles account login status in Firebase
  Future<userfb.User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      logger.d('Signing in');
      userfb.UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return credential.user;
    } on userfb.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        toastErrorPopUp(
            "User with the email address entered not found in system's database");
      } else if (e.code == "invalid-email") {
        toastErrorPopUp("Email address entered is not valid");
      } else if (e.code == 'wrong-password') {
        toastErrorPopUp("Wrong password");
      } else if (e.code == 'invalid-credentials') {
        toastErrorPopUp("Wrong credentials");
      }
    } catch (e) {
      logger.e('Sign In Error: $e');
      return null;
    }

    return null;
  }

//Handles account signout in Firebase
  Future<void> signOut(BuildContext context) async {
    currentUser = null;
    await _firebaseAuth.signOut();
  }

//Handles account passward reset in Firebase
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      logger.e("Failed to send password reset email: ${e.toString()}");
    }
  }

//Handles account verification through the account email
  Future<void> sendVerificationEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      logger.e("Failed ${e.toString()}");
    }
  }

//Handles error feedback to users
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
