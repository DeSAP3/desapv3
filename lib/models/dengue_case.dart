import 'package:cloud_firestore/cloud_firestore.dart';

class DengueCase {
  String? dCaseID;
  String? patientName;
  int? patientAge;
  Timestamp? dateRPD;
  String? address;
  double? infectedCoordsX;
  double? infectedCoordsY;
  String? officerName;
  String? status;
  String? userID;
  String? ovitrapID;
  String? dataAnalyticsID;

  DengueCase(
      this.dCaseID,
      this.patientName,
      this.patientAge,
      this.dateRPD,
      this.address,
      this.infectedCoordsX,
      this.infectedCoordsY,
      this.officerName,
      this.status,
      this.userID,
      this.ovitrapID,
      this.dataAnalyticsID);

  factory DengueCase.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final dCaseID = doc.id;
    final patientName = data['patientName'] ?? '';
    final patientAge = data['patientAge'] ?? 0;
    final dateRPD = data['dateRPD'] ?? Timestamp.now();
    final address = data['address'] ?? '';
    final infectedCoordsX = data['infectedCoordsX'] ?? 1.2;
    final infectedCoordsY = data['infectedCoordsY'] ?? 1.2;
    final officerName = data['officerName'] ?? '';
    final status = data['status'] ?? '';
    final userID = data['isActive'] ?? '';
    final ovitrapID = data['ovitrapID'] ?? '';
    final dataAnalyticsID = data['dataAnalyticsID'] ?? '';

    return DengueCase(
        dCaseID,
        patientName,
        patientAge,
        dateRPD,
        address,
        infectedCoordsX,
        infectedCoordsY,
        officerName,
        status,
        userID,
        ovitrapID,
        dataAnalyticsID);
  }
}
