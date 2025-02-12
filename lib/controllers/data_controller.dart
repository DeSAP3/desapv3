import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/cup.dart';
import 'package:desapv3/models/ovitrap.dart';
import 'package:desapv3/reuseable_widget/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class DataController with ChangeNotifier {
  final List<OviTrap> _oviTrapList = [];
  final List<Cup> _cupList = [];

  bool _isFetchingOviTrap = false;
  bool _isFetchingCups = false;

  bool get isOviTrapLoaded => _oviTrapList.isNotEmpty;
  bool get isCupLoaded => _cupList.isNotEmpty;

  List<OviTrap> get oviTrapList => _oviTrapList;
  List<Cup> get cupList => _cupList;

  bool get isFetchingOviTrap => _isFetchingOviTrap;
  bool get isFetchingCups => _isFetchingCups;

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  final logger = Logger();

  //Locality Creators
  Future<void> addOviTrap(
      String location,
      String member,
      String status,
      int epiWeekInstl,
      int epiWeekRmv,
      Timestamp instlTime,
      Timestamp removeTime) async {
    try {
      Map<String, dynamic> ovitrapData = {
        'location': location,
        'member': member,
        'status': status,
        'epiWeekInstl': epiWeekInstl,
        'epiWeekRmv': epiWeekRmv,
        'instlTime': instlTime,
        'removeTime': removeTime,
      };

      // Add to Firestore
      await dBaseRef
          .collection('OviTrap')
          .add(ovitrapData)
          .then((querySnapshot) {
        OviTrap newOviTrap = OviTrap(
            querySnapshot.id.toString(),
            location,
            member,
            status,
            epiWeekInstl,
            epiWeekRmv,
            instlTime,
            removeTime, []);
        _oviTrapList.add(newOviTrap);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  //Locality Readers
  Future<List<OviTrap>> fetchOviTrap() async {
    try {
      _oviTrapList.clear();
      _isFetchingOviTrap = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await dBaseRef.collection('OviTrap').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        logger.d(data);

        OviTrap ovitrap = OviTrap(
            doc.id,
            data['location'] ?? '',
            data['member'] ?? '',
            data['status'] ?? '',
            // int.tryParse(data['epiWeekInstl'] ?? '0') ?? 0,
            // int.tryParse(data['epiWeekRmv'] ?? '0') ?? 0,
            data['epiWeekInstl'] ?? 0,
            data['epiWeekRmv'] ?? 0,
            (data['instlTime'] as Timestamp?) ?? Timestamp.now(),
            (data['removeTime'] as Timestamp?) ?? Timestamp.now(),
            data['cupList'] is Iterable ? List.from(data['cupList']) : []);

        logger.d(ovitrap.instlTime);

        _oviTrapList.add(ovitrap);
        logger.d(ovitrap);
      }

      notifyListeners();
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingOviTrap = false;
      notifyListeners();
    }

    return _oviTrapList;
  }

  //Locality Updater
  Future<void> updateOviTrap(OviTrap newOviTrap, int index) async {
    try {
      // Update in Firestore
      await dBaseRef.collection('OviTrap').doc(newOviTrap.oviTrapID).update({
        'location': newOviTrap.location,
        'member': newOviTrap.member,
        'status': newOviTrap.status,
        'epiWeekInstl': newOviTrap.epiWeekInstl,
        'epiWeekRmv': newOviTrap.epiWeekRmv,
        'instlTime': newOviTrap.instlTime,
        'removeTime': newOviTrap.removeTime,
      });

      // Optionally fetch updated data or directly add the new object to the list
      _oviTrapList.update(index, newOviTrap);
      notifyListeners();
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  Future<void> deleteOviTrap(OviTrap delOviTrap) async {
    await dBaseRef
        .collection('OviTrap')
        .doc(delOviTrap.oviTrapID)
        .delete()
        .then((doc) => logger.d("Document deleted"),
            onError: (e) => logger.e("Error deleting document: $e"));

    _oviTrapList.remove(delOviTrap);
  }

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
        'localityCaseID': oviTrapID //This needs change
      };

      // Add to Firestore
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
      notifyListeners();

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
            data['localityCaseID'] ?? ''); // Also this change

        logger.d(cup.cupID);

        _cupList.add(cup);
        logger.d(cup);
      }

      notifyListeners();
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingOviTrap = false;
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
        'localityCaseID': newCup.localityCaseID //This might need change
      });

      int currentCupIndex =
          _cupList.indexWhere((cup) => cup.cupID == newCup.cupID);

      if (currentCupIndex != -1) {
        _cupList[currentCupIndex] = newCup;
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
        (cup) => (cup.localityCaseID == oviTrapID) && cup.isActive,
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
  }
}
