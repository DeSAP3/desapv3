import 'package:cloud_firestore/cloud_firestore.dart';
//This model contains the information required for the Ovitrap class
class OviTrap {
  String oviTrapID;
  String? location;
  String? member;
  String? status;
  int? epiWeekInstl;
  int? epiWeekRmv;
  Timestamp? instlTime;
  Timestamp? removeTime;
  String? dengueCaseID;

  OviTrap(
      this.oviTrapID,
      this.location,
      this.member,
      this.status,
      this.epiWeekInstl,
      this.epiWeekRmv,
      this.instlTime,
      this.removeTime,
      this.dengueCaseID);

  factory OviTrap.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final oviTrapID = doc.id;
    final location = data['location'] ?? '';
    final member = data['member'] ?? '';
    final status = data['status'] ?? '';
    final epiWeekInstl = data['epiWeekInstl'] ?? 0;
    final epiWeekRmv = data['epiWeekRmv'] ?? 0;
    final instlTime = (data['instlTime'] as Timestamp?) ?? Timestamp.now();
    final removeTime = (data['removeTime'] as Timestamp?) ?? Timestamp.now();
    final dengueCaseID = (data['dengueCaseID']) ?? '';

    return OviTrap(oviTrapID, location, member, status, epiWeekInstl,
        epiWeekRmv, instlTime, removeTime, dengueCaseID);
  }
}
