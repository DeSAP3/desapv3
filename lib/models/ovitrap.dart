import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/cup.dart';

class Ovitrap {
  String oviTrapID;
  String location;
  String member;
  String status;
  int epiWeekInstl;
  int epiWeekRmv;
  Timestamp instlTime;
  Timestamp removeTime;
  String cupID;
  Cup? currentCup;
  //Cup('', 0, 0.0, 0.0, 0, '')

  Ovitrap(
      this.oviTrapID,
      this.location,
      this.member,
      this.status,
      this.epiWeekInstl,
      this.epiWeekRmv,
      this.instlTime,
      this.removeTime,
      this.cupID);

  factory Ovitrap.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final oviTrapID = doc.id;
    final location = data['location'] ?? '';
    final member = data['member'] ?? '';
    final status = data['status'] ?? '';
    // final epiWeekInstl = int.tryParse(data['epiWeekInstl'] ?? '0') ?? 0;
    // final epiWeekRmv = int.tryParse(data['epiWeekRmv'] ?? '0') ?? 0;
    final epiWeekInstl = data['epiWeekInstl'] ?? 0;
    final epiWeekRmv = data['epiWeekRmv'] ?? 0;
    final instlTime = (data['instlTime'] as Timestamp?) ?? Timestamp.now();
    final removeTime = (data['removeTime'] as Timestamp?) ?? Timestamp.now();
    final cupID = data['cupID'] ?? '';

    return Ovitrap(oviTrapID, location, member, status, epiWeekInstl,
        epiWeekRmv, instlTime, removeTime, cupID);
  }

  void setCup(List<Cup> cupList) {
    for (Cup cup in cupList) {
      if (cup.cupID == cupID) {
        currentCup = cup;
      }
    }
  }
}
