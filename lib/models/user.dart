import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? userID;
  String? email;
  String? fName;
  String? lName;
  String? staffID;
  String? address;
  int? role;

  User(this.userID, this.email, this.fName, this.lName, this.staffID,
      this.address, this.role);

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final userID = doc.id;
    final email = data['email'] ?? "";
    final fName = data['fName'] ?? "John";
    final lName = data['lName'] ?? "Doe";
    final staffID = data['staffID'] ?? 0;
    final address = data['address'] ?? '';
    final role = data['role'] ?? assignRole(staffID);

    return User(userID, email, fName, lName, staffID, address, role);
  }
}

int assignRole(staffID) {
  try {
    //I assume the staffID is related to their position
    String staffIDPrefix = staffID.substring(0, 4);

    if (staffIDPrefix == "") {
      return 1; //HOAdmin
    } else if (staffIDPrefix == "") {
      return 2; //Entomologist
    } else if (staffIDPrefix == "") {
      return 3; //PHA
    } else {
      return 0; //DengueCaseReporter
    }
  } catch (e) {
    return -1; //In case of error
  }
}
