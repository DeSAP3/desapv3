import 'package:cloud_firestore/cloud_firestore.dart';

class DengueCase {
  String? dCaseID;
  String? patientName;
  String? patientAge;
  Timestamp? dateRPD;
  double? infectedCoordsX;
  double? infectedCoordY;
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
      this.infectedCoordsX,
      this.infectedCoordY,
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
        infectedCoordsX,
        infectedCoordsY,
        officerName,
        status,
        userID,
        ovitrapID,
        dataAnalyticsID);
  }
}
