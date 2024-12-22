import 'package:cloud_firestore/cloud_firestore.dart';

class Cup {
  String? cupID;
  int? eggCount;
  double? gpsX;
  double? gpsY;
  int? larvaeCount;
  String? status;
  String? localityCaseID;

  Cup(this.cupID, this.eggCount, this.gpsX, this.gpsY, this.larvaeCount,
      this.status, this.localityCaseID);

  factory Cup.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final cupID = doc.id;
    final eggCount = data['eggCount'] ?? 0;
    final gpsX = data['gpsX'] ?? 1.2;
    final gpsY = data['gpsX'] ?? 1.2;
    final larvaeCount = data['larvaeCount'] ?? 0;
    final status = data['status'] ?? '';
    final localityCaseID = data['localityCaseID'] ?? '';

    return Cup(cupID, eggCount, gpsX, gpsY, larvaeCount, status, localityCaseID);
  }
}
