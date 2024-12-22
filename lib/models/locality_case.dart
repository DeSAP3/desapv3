import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/cup.dart';

class LocalityCase {
  String oviTrapID;
  String? location;
  String? member;
  String? status;
  int? epiWeekInstl;
  int? epiWeekRmv;
  Timestamp? instlTime;
  Timestamp? removeTime;
  List<Cup>? cupList;


  LocalityCase(
      this.oviTrapID,
      this.location,
      this.member,
      this.status,
      this.epiWeekInstl,
      this.epiWeekRmv,
      this.instlTime,
      this.removeTime,
      this.cupList);

  factory LocalityCase.fromFirestore(DocumentSnapshot doc) {
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
    final cupList = data['cupList'] is Iterable ? List.from(data['cupList']):[];

    return LocalityCase(oviTrapID, location, member, status, epiWeekInstl,
        epiWeekRmv, instlTime, removeTime, cupList.cast<Cup>());
  }
}
