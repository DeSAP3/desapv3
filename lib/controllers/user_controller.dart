import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/user.dart' as model;
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {
  model.User? _user;

  model.User? get user => _user;

  Future<void> fetchUser(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('User').doc(uid).get();
    _user = model.User.fromFirestore(doc);
    notifyListeners();
  }

  void setUser(model.User user) {
    _user = user;
    notifyListeners();
  }
}
