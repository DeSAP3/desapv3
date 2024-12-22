import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/cup.dart';
import 'package:desapv3/models/locality_case.dart';
import 'package:desapv3/reuseable_widget/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class DataController with ChangeNotifier {
  final List<LocalityCase> _localityCaseList = [];
  final List<Cup> _cupList = [];

  bool _isFetchingLocalityCase = false;
  bool _isFetchingCups = false;

  bool get isLocalityCaseLoaded => _localityCaseList.isNotEmpty;
  bool get isCupLoaded => _cupList.isNotEmpty;

  List<LocalityCase> get localityCaseList => _localityCaseList;
  List<Cup> get cupList => _cupList;

  bool get isFetchingLocalityCase => _isFetchingLocalityCase;
  bool get isFetchingCups => _isFetchingCups;

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  final logger = Logger();

  //Locality Creators
  Future<void> addLocalityCase(
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
        LocalityCase newLocalityCase = LocalityCase(
            querySnapshot.id.toString(),
            location,
            member,
            status,
            epiWeekInstl,
            epiWeekRmv,
            instlTime,
            removeTime, []);
        _localityCaseList.add(newLocalityCase);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  //Locality Readers
  Future<List<LocalityCase>> fetchLocalityCase() async {
    try {
      _localityCaseList.clear();
      _isFetchingLocalityCase = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await dBaseRef.collection('OviTrap').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        logger.d(data);

        LocalityCase ovitrap = LocalityCase(
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

        _localityCaseList.add(ovitrap);
        logger.d(ovitrap);
      }

      notifyListeners();
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingLocalityCase = false;
      notifyListeners();
    }

    return _localityCaseList;
  }

  //Locality Updater
  Future<void> updateLocalityCase(
      LocalityCase newLocalityCase, int index) async {
    try {
      // Map<String, dynamic> newOviTrapData = {
      //   'location': newLocalityCase.location,
      //   'member': newLocalityCase.member,
      //   'status': newLocalityCase.status,
      //   'epiWeekInstl': newLocalityCase.epiWeekInstl,
      //   'epiWeekRmv': newLocalityCase.epiWeekRmv,
      //   'instlTime': newLocalityCase.instlTime,
      //   'removeTime': newLocalityCase.removeTime,
      //   'cupID': newLocalityCase.cupID,
      // };

      // Update in Firestore
      await dBaseRef
          .collection('OviTrap')
          .doc(newLocalityCase.oviTrapID)
          .update({
        'location': newLocalityCase.location,
        'member': newLocalityCase.member,
        'status': newLocalityCase.status,
        'epiWeekInstl': newLocalityCase.epiWeekInstl,
        'epiWeekRmv': newLocalityCase.epiWeekRmv,
        'instlTime': newLocalityCase.instlTime,
        'removeTime': newLocalityCase.removeTime,
      });

      // Optionally fetch updated data or directly add the new object to the list
      _localityCaseList.update(index, newLocalityCase);
      notifyListeners();
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  Future<void> deleteLocalityCase(LocalityCase delLocalityCase) async {
    await dBaseRef
        .collection('OviTrap')
        .doc(delLocalityCase.oviTrapID)
        .delete()
        .then((doc) => logger.d("Document deleted"),
            onError: (e) => logger.e("Error deleting document: $e"));

    _localityCaseList.remove(delLocalityCase);
  }

  // Future<List<Cup>> fetchCups() async {
  //   try {
  //     _cupList.clear();
  //     _isFetchingCups = true;
  //     notifyListeners();

  //     QuerySnapshot querySnapshot = await dBaseRef.collection('Cup').get();

  //     for (var doc in querySnapshot.docs) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

  //       Cup cup = Cup(
  //           doc.id,
  //           data['eggCount'] ?? 0,
  //           data['gpsX'] ?? 0.0,
  //           data['gpsY'] ?? 0.0,
  //           data['larvaeCount'] ?? 0,
  //           data['status'] ?? '',
  //           data['localityCaseID'] ?? '');

  //       _cupList.add(cup);
  //       notifyListeners();
  //       logger.d(cup.cupID);
  //     }
  //   } catch (e) {
  //     logger.e("Error");
  //     rethrow;
  //   }

  //   return _cupList;
  // }

  //Cup Creator
  Future<void> addCup(int eggCount, double gpsX, double gpsY, int larvaeCount,
      String status, String localityCaseID) async {
    try {
      Map<String, dynamic> cupData = {
        'eggCount': eggCount,
        'gpsX': gpsX,
        'gpsY': gpsY,
        'larvaeCount': larvaeCount,
        'status': status,
        'localityCaseID': localityCaseID
      };

      // Add to Firestore
      await dBaseRef.collection('Cup').add(cupData).then((querySnapshot) {
        Cup newCup = Cup(querySnapshot.id.toString(), eggCount, gpsX, gpsY,
            larvaeCount, status, localityCaseID);
        _cupList.add(newCup);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
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

        logger.d(data);

        Cup cup = Cup(
            doc.id,
            data['eggCount'] ?? 0,
            data['gpsX'] ?? 0.0,
            data['gpsY'] ?? 0.0,
            data['larvaeCount'] ?? 0,
            data['status'] ?? '',
            data['localityCaseID'] ?? '');

        logger.d(cup.cupID);

        _cupList.add(cup);
        logger.d(cup);
      }

      notifyListeners();
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingLocalityCase = false;
      notifyListeners();
    }

    return _cupList;
  }

  //Cup Updater
  Future<void> updateCup(Cup newCup) async {
    try {
      // Map<String, dynamic> newOviTrapData = {
      //   'location': newLocalityCase.location,
      //   'member': newLocalityCase.member,
      //   'status': newLocalityCase.status,
      //   'epiWeekInstl': newLocalityCase.epiWeekInstl,
      //   'epiWeekRmv': newLocalityCase.epiWeekRmv,
      //   'instlTime': newLocalityCase.instlTime,
      //   'removeTime': newLocalityCase.removeTime,
      //   'cupID': newLocalityCase.cupID,
      // };

      // Update in Firestore
      await dBaseRef.collection('Cup').doc(newCup.cupID).update({
        'eggCount': newCup.eggCount,
        'gpsX': newCup.gpsX,
        'gpsY': newCup.gpsY,
        'larvaeCount': newCup.larvaeCount,
        'status': newCup.status,
        'localityCaseID': newCup.localityCaseID
      });

      // Optionally fetch updated data or directly add the new object to the list
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

  //Cup Deletor
  Future<void> deleteCup(Cup delCup) async {
    await dBaseRef.collection('OviTrap').doc(delCup.cupID).delete().then(
        (doc) => logger.d("Cup deleted"),
        onError: (e) => logger.e("Error deleting Cup: $e"));

    _cupList.remove(delCup);
  }
}
