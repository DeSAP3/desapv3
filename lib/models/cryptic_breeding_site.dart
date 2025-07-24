import 'package:cloud_firestore/cloud_firestore.dart';
//This model contains the information required for the Cryptic Breeding Site class
class CrypticBreedingSite {
  String breedingSiteID;
  double? siteGpsX;
  double? siteGpsY;

  CrypticBreedingSite(this.breedingSiteID,this.siteGpsX, this.siteGpsY);

  factory CrypticBreedingSite.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final breedingSiteID = doc.id;
    final siteGpsX = data['gpsX'];
    final siteGpsY = data['gpsY'];

    return CrypticBreedingSite(breedingSiteID, siteGpsX, siteGpsY);
  }
}
