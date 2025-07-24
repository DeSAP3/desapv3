import 'package:cloud_firestore/cloud_firestore.dart';
//This model contains the information required for the Cup class
class Cup {
  String? cupID;
  int? eggCount;
  double? gpsX;
  double? gpsY;
  int? larvaeCount;
  String? status;
  bool isActive = false;
  String? ovitrapID;

  Cup(this.cupID, this.eggCount, this.gpsX, this.gpsY, this.larvaeCount,
      this.status, this.isActive, this.ovitrapID);

  factory Cup.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final cupID = doc.id;
    final eggCount = data['eggCount'] ?? 0;
    final gpsX = data['gpsX'] ?? 1.2;
    final gpsY = data['gpsY'] ?? 1.2;
    final larvaeCount = data['larvaeCount'] ?? 0;
    final status = data['status'] ?? '';
    final isActive = data['isActive'] ?? false;
    final ovitrapID = data['localityCaseID'] ?? '';

    return Cup(
        cupID, eggCount, gpsX, gpsY, larvaeCount, status, isActive, ovitrapID);
  }
}
