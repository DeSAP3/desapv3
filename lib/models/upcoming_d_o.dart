import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingDO {
  String? uDOID;
  double? coordX;
  double? coordY;
  Timestamp? dateCreation;
  double? humidity;
  double? maxTemp;
  double? minTemp;
  double? predictEgg;
  double? predictEggExtra;
  double? windSpeed;

  UpcomingDO(
      this.uDOID,
      this.coordX,
      this.coordY,
      this.dateCreation,
      this.humidity,
      this.maxTemp,
      this.minTemp,
      this.predictEgg,
      this.predictEggExtra,
      this.windSpeed);

  factory UpcomingDO.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final uDOID = doc.id;
    final coordX = data['coordX'] ?? 0.0;
    final coordY = data['coordX'] ?? 0.0;
    final dateCreation = data['dateCreation'] ?? Timestamp.now();
    final humidity = data['staffID'] ?? '';
    final maxTemp = data['maxTemp'] ?? '';
    final minTemp = data['minTemp'] ?? '';
    final predictEgg = data['predictEgg'] ?? 0;
    final predictEggExtra = data['predictEggExtra'] ?? 0;
    final windSpeed = data['windSpeed'] ?? 0;

    return UpcomingDO(uDOID, coordX, coordY, dateCreation, humidity, maxTemp,
        minTemp, predictEgg, predictEggExtra, windSpeed);
  }
}
