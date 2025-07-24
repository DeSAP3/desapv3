import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/cup.dart';
import 'package:desapv3/reuseable_widget/string_extensions.dart';
import 'package:desapv3/services/location_map_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class CupViewModel with ChangeNotifier {
  final List<Cup> _cupList = [];

  bool _isFetchingCups = false; //Is a cup fetching in progress?
  bool get isFetchingCups => _isFetchingCups; //Get the status of the fetching progress
  bool get isCupLoaded => _cupList.isNotEmpty;//Is the list empty?
  List<Cup> get cupList => _cupList; //Return the cup list

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  LocationServices locationService = LocationServices();
  bool _isFetchingLocation = false;
  bool get isFetchingLocation => _isFetchingLocation;
  Position? newLocation;
  Placemark? newCoordinates;

  final logger = Logger();

  //Cup Creator
  Future<void> addCup(int eggCount, double gpsX, double gpsY, int larvaeCount,
      String status, bool isActive, String oviTrapID) async {
    try {
      Map<String, dynamic> cupData = {
        'eggCount': eggCount,
        'gpsX': gpsX,
        'gpsY': gpsY,
        'larvaeCount': larvaeCount,
        'status': status,
        'isActive': isActive,
        'localityCaseID': oviTrapID
      };

      await dBaseRef.collection('Cup').add(cupData).then((querySnapshot) {
        Cup newCup = Cup(querySnapshot.id.toString(), eggCount, gpsX, gpsY,
            larvaeCount, status, isActive, oviTrapID);
        _cupList.add(newCup);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Cup: ${e.toString()}');
    }
  }

  //Cup Readers
  Future<List<Cup>> fetchCups() async {
    try {
      _cupList.clear();
      _isFetchingCups = true;

      QuerySnapshot querySnapshot = await dBaseRef.collection('Cup').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        Cup cup = Cup(
            doc.id,
            data['eggCount'] ?? 0,
            data['gpsX'] ?? 0.0,
            data['gpsY'] ?? 0.0,
            data['larvaeCount'] ?? 0,
            data['status'] ?? '',
            data['isActive'] ?? false,
            data['localityCaseID'] ?? '');

        logger.d(cup.cupID);

        _cupList.add(cup);
        logger.d(cup);
      }
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingCups = false;
      notifyListeners();
    }

    return _cupList;
  }

  //Cup Updater
  Future<void> updateCup(Cup newCup) async {
    try {
      await dBaseRef.collection('Cup').doc(newCup.cupID).update({
        'eggCount': newCup.eggCount,
        'gpsX': newCup.gpsX,
        'gpsY': newCup.gpsY,
        'larvaeCount': newCup.larvaeCount,
        'status': newCup.status,
        'isActive': newCup.isActive,
        'localityCaseID': newCup.ovitrapID
      });

      int currentCupIndex =
          _cupList.indexWhere((cup) => cup.cupID == newCup.cupID);

      if (currentCupIndex != -1) {
        _cupList.update(currentCupIndex, newCup);
        notifyListeners();
      } else {
        logger.e('Cup with ID ${newCup.cupID} not found in the list');
      }
    } catch (e) {
      logger.e('Error updating Cup: ${e.toString()}');
    }
  }

  Future<void> updateCupActivity(String oviTrapID, Cup cupToActive) async {
    try {
      Cup? cupToDeactivate = cupList.firstWhere(
        (cup) => (cup.ovitrapID == oviTrapID) && cup.isActive,
        orElse: () => Cup(null, null, null, null, null, null, false, null),
      );
      //Add onError to know what's the error here

      if (cupToDeactivate.cupID != null) {
        await dBaseRef.collection('Cup').doc(cupToDeactivate.cupID).update({
          'isActive': false,
        }).then((e) async {
          //Need to separate this
          logger.d("Deactivate Cup ${cupToDeactivate.cupID}");
          int deactivateCupIndex =
              _cupList.indexWhere((cup) => cup.cupID == cupToDeactivate.cupID);

          if (deactivateCupIndex != -1) {
            _cupList[deactivateCupIndex] = cupToDeactivate;
            notifyListeners();
          } else {
            logger.e('Cup with ID ${cupToActive.cupID} not found in the list');
          }
        });
      }

      await dBaseRef.collection('Cup').doc(cupToActive.cupID).update({
        'isActive': true,
      }).then((e) {
        logger.d("Activate Cup ${cupToActive.cupID}");
        int activateCupIndex =
            _cupList.indexWhere((cup) => cup.cupID == cupToActive.cupID);

        if (activateCupIndex != -1) {
          _cupList[activateCupIndex] = cupToActive;
          notifyListeners();
        } else {
          logger.e('Cup with ID ${cupToActive.cupID} not found in the list');
        }
      });
    } catch (e) {
      logger.e('Error updating Cup: ${e.toString()}');
    }
  }

  //Cup Deletor
  Future<void> deleteCup(Cup delCup) async {
    await dBaseRef.collection('OviTrap').doc(delCup.cupID).delete().then(
        (doc) => logger.d("Cup deleted"),
        onError: (e) => logger.e("Error deleting Cup: $e"));

    _cupList.remove(delCup);
    notifyListeners();
  }

  //Cup Location Setter
  Future<void> setCupLocation() async {
    _isFetchingLocation = true;
    newLocation = await locationService.getCurrentLocation();
    newCoordinates = await locationService.getAddress(newLocation!);
    _isFetchingCups = false;
    notifyListeners();
  }

//Cup Location Getter
  Future<Position?> getCurrentCupLocation() async {
    if (newLocation != null) {
      return newLocation;
    } else {
      await setCupLocation();
      notifyListeners();
      return newLocation; //Maybe a better error fixing
    }
  }

//Total up all eggs from all ovitraps including inactive cups
  int calcTotalEgg() {
    int totalMosquitoEgg = 0;

    for (Cup cup in cupList) {
      totalMosquitoEgg += cup.eggCount!;
    }

    notifyListeners();
    return totalMosquitoEgg;
  }
}
