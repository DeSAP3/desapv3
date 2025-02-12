import 'package:cloud_firestore/cloud_firestore.dart';

class CrypticBreedingSite {
  String breedingSiteID;
  double? siteGpsX;
  double? siteGpsY;

  CrypticBreedingSite(this.breedingSiteID,this.siteGpsX, this.siteGpsY);

  factory CrypticBreedingSite.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final breedingSiteID = doc.id;
    final siteGpsX = doc['gpsX'];
    final siteGpsY = doc['gpsY'];

    return CrypticBreedingSite(breedingSiteID, siteGpsX, siteGpsY);
  }
}
