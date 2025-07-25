import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/dengue_case.dart';
import 'package:desapv3/reuseable_widget/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class DengueCaseViewModel with ChangeNotifier {
  final List<DengueCase> _dengueCaseList = [];

  bool _isFetchingDengueCase = false; //Is a dengue case fetching in progress?

  bool get isFetchingDengueCase =>
      _isFetchingDengueCase; //Get the status of the fetching progress?

  bool get isDengueCaseLoaded =>
      _dengueCaseList.isNotEmpty; //Is the list empty?

  List<DengueCase> get dengueCaseList =>
      _dengueCaseList; //Return the dengue case list

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  final logger = Logger();

  //Dengue Case Creator
  Future<void> addDengueCase(
      String patientName,
      int patientAge,
      Timestamp dateRPD,
      String address,
      double infectedCoordsX,
      double infectedCoordsY,
      String officerName,
      String status,
      String userID,
      String ovitrapID,
      String dataAnalyticsID) async {
    try {
      Map<String, dynamic> dengueCaseData = {
        'patientName': patientName,
        'patientAge': patientAge,
        'dateRPD': dateRPD,
        'address': address,
        'infectedCoordsX': infectedCoordsX,
        'infectedCoordsY': infectedCoordsY,
        'officerName': officerName,
        'status': status,
        'userID': userID,
        'ovitrapID': ovitrapID,
        'dataAnalyticsID': dataAnalyticsID
      };

      await dBaseRef
          .collection('DengueCase')
          .add(dengueCaseData)
          .then((querySnapshot) {
        DengueCase newDengueCase = DengueCase(
            querySnapshot.id.toString(),
            patientName,
            patientAge,
            dateRPD,
            address,
            infectedCoordsX,
            infectedCoordsY,
            officerName,
            status,
            userID,
            ovitrapID,
            dataAnalyticsID);
        _dengueCaseList.add(newDengueCase);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Dengue Case: ${e.toString()}');
    }
  }

//Dengue Case Reader
  Future<List<DengueCase>> fetchDengueCase() async {
    try {
      _dengueCaseList.clear();
      _isFetchingDengueCase = true;

      QuerySnapshot querySnapshot =
          await dBaseRef.collection('DengueCase').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        DengueCase dc = DengueCase(
          doc.id,
          data['patientName'] ?? '',
          data['patientAge'] ?? 0,
          data['dateRPD'] ?? Timestamp.now(),
          data['address'] ?? '',
          data['infectedCoordsX'] ?? 1.2,
          data['infectedCoordsY'] ?? 1.2,
          data['officerName'] ?? '',
          data['status'] ?? '',
          data['isActive'] ?? '',
          data['ovitrapID'] ?? '',
          data['dataAnalyticsID'] ?? '',
        );

        logger.d(dc.status);

        _dengueCaseList.add(dc);
        logger.d(dc);
      }
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingDengueCase = false;
      notifyListeners();
    }

    return _dengueCaseList;
  }

  //Dengue Case Updater
  Future<void> updateDengueCase(DengueCase newDengueCase, int index) async {
    try {
      await dBaseRef
          .collection('DengueCase')
          .doc(newDengueCase.dCaseID)
          .update({
        'patientName': newDengueCase.patientName,
        'patientAge': newDengueCase.patientAge,
        'dateRPD': newDengueCase.dateRPD,
        'address': newDengueCase.address,
        'infectedCoordsX': newDengueCase.infectedCoordsX,
        'infectedCoordsY': newDengueCase.infectedCoordsY,
        'officerName': newDengueCase.officerName,
        'status': newDengueCase.status,
        'userID': newDengueCase.userID,
        'ovitrapID': newDengueCase.ovitrapID,
        'dataAnalyticsID': newDengueCase.dataAnalyticsID
      });

      // Optionally fetch updated data or directly add the new object to the list
      _dengueCaseList.update(index, newDengueCase);
      notifyListeners();
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

//Update Dengue Case Status in the Firebase
  Future<void> updateCaseStatus(
      DengueCase newDengueCase, String newStatus) async {
    try {
      await dBaseRef
          .collection('DengueCase')
          .doc(newDengueCase.dCaseID)
          .update({
        'status': newStatus,
      });


      final index = _dengueCaseList
          .indexWhere((dc) => dc.dCaseID == newDengueCase.dCaseID);
      _dengueCaseList.update(index, newDengueCase);
      notifyListeners();
    } catch (e) {
      logger.e('Error Updating Dengue Case Status: ${e.toString()}');
    }
  }

  Future<void> deleteDengueCase(DengueCase delDC) async {
    await dBaseRef.collection('DengueCase').doc(delDC.dCaseID).delete().then(
        (doc) => logger.d("Ovitrap deleted"),
        onError: (e) => logger.e("Error deleting document: $e"));

    _dengueCaseList.remove(delDC);
    notifyListeners();
  }
}
