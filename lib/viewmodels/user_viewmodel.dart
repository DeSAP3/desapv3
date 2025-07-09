import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserViewModel with ChangeNotifier {
  model.User? _user;

  model.User? get user => _user;

  final _currentUser = FirebaseAuth.instance.currentUser;

  Future<void> fetchCurrentUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('User')
        .doc(_currentUser?.uid)
        .get();
    _user = model.User.fromFirestore(doc);
    notifyListeners();
  }

  void setUser(model.User user) {
    _user = user;
    notifyListeners();
  }

  String getRole(int roleNum) {
    if (roleNum == 1) {
      return "Admin";
    }
    else if (roleNum == 2) {
      return "Entomologist";
    }
    else if (roleNum == 3) {
      return "Operation Member";
    }
    else {
      return "DC Reporter";
    }
  }
}
