import 'package:cloud_firestore/cloud_firestore.dart';
//This model contains the information required for the User class
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
    final staffID = data['staffID'] ?? '';
    final address = data['address'] ?? '';
    final role = data['role'] ?? assignRole(staffID);

    return User(userID, email, fName, lName, staffID, address, role);
  }
}

int assignRole(String staffID) {
  try {
    //I assume the staffID is related to their position
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
    return -1; //In case of error
  }
}
