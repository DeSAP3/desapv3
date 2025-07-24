import 'package:cloud_firestore/cloud_firestore.dart';
//This model contains the information required for the Upcoming Dengue Outbreak class
class UpcomingDengueOutbreak {
  String? uDOID;
  double? coordX;
  double? coordY;
  Timestamp? dateCreation;
  double? humidity;
  double? maxTemp;
  double? minTemp;
  int? predictEgg;
  int? predictEggExtra;
  double? windSpeed;

  UpcomingDengueOutbreak(
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

  factory UpcomingDengueOutbreak.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final uDOID = doc.id;
    final coordX = data['coordX'] ?? 0.0;
    final coordY = data['coordY'] ?? 0.0;
    final dateCreation = data['dateCreation'] ?? Timestamp.now();
    final humidity = data['humidity'] ?? 0.0;
    final maxTemp = data['maxTemp'] ?? 0.0;
    final minTemp = data['minTemp'] ?? 0.0;
    final predictEgg = data['predictEgg'] ?? 0;
    final predictEggExtra = data['predictEggExtra'] ?? 0;
    final windSpeed = data['windSpeed'] ?? 0;

    return UpcomingDengueOutbreak(uDOID, coordX, coordY, dateCreation, humidity, maxTemp,
        minTemp, predictEgg, predictEggExtra, windSpeed);
  }
}
