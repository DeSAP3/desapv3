import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/cryptic_breeding_site.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CrypticBreedingSiteViewModel with ChangeNotifier {
  final List<CrypticBreedingSite> _crypticBreedingSiteList = [];

  bool _isFetchingCrypticBreedingSite = false; //Is a cryptic breeding site fetching in progress?

  bool get isFetchingCrypticBreedingSite => _isFetchingCrypticBreedingSite;  //Get the status of the fetching progress

  bool get isCrypticBreedingSiteLoaded => _crypticBreedingSiteList.isNotEmpty; //Is the list empty?

  List<CrypticBreedingSite> get crypticBreedingSiteList =>
      _crypticBreedingSiteList; //Return the cryptic breeding site list

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  final logger = Logger();

  //CrypticBreedingSite Creator
  Future<void> addCrypticBreedingSite(double coordX, double coordY) async {
    try {
      Map<String, dynamic> crypticBreedingData = {
        'gpsX': coordX,
        'gpsY': coordY
      };

      await dBaseRef
          .collection('UpcomingDengueOutbreak')
          .add(crypticBreedingData)
          .then((querySnapshot) {
        CrypticBreedingSite newCrypticBreedingSite =
            CrypticBreedingSite(querySnapshot.id.toString(), coordX, coordY);
        _crypticBreedingSiteList.add(newCrypticBreedingSite);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  //CrypticBreedingSite Readers
  Future<List<CrypticBreedingSite>> fetchAllCrypticBreedingSite() async {
    try {
      _crypticBreedingSiteList.clear();
      _isFetchingCrypticBreedingSite = true;

      QuerySnapshot querySnapshot =
          await dBaseRef.collection('CrypticBreedingSite').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        CrypticBreedingSite cBS = CrypticBreedingSite(
          doc.id,
          data['coordX'] ?? 0.0,
          data['coordY'] ?? 0.0,
        );

        _crypticBreedingSiteList.add(cBS);
        logger.d(cBS);
      }
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingCrypticBreedingSite = false;
      notifyListeners();
    }

    return _crypticBreedingSiteList;
  }

//CrypticBreedingSite Deletor
  Future<void> deleteCrypticBreedingSite(CrypticBreedingSite delCBS) async {
    await dBaseRef
        .collection('UpcomingDengueOutbreak')
        .doc(delCBS.breedingSiteID)
        .delete()
        .then((doc) => logger.d("Upcoming Dengue Outbreak deleted"),
            onError: (e) => logger.e("Error deleting document: $e"));

    _crypticBreedingSiteList.remove(delCBS);
    notifyListeners();
  }
}
