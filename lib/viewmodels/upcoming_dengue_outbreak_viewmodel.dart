import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/upcoming_dengue_outbreak.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class UpcomingDengueOutbreakViewModel with ChangeNotifier {
  final List<UpcomingDengueOutbreak> _upcomingDengueOutbreakList = [];

  bool _isFetchingUpcomingDengueOutbreak = false; //Is an upcoming dengue outbreak fetching in progress?

  bool get isFetchingUpcomingDengueOutbreak =>
      _isFetchingUpcomingDengueOutbreak; //Get the status of the fetching progress

  bool get isUpcomingDengueOutbreakLoaded =>
      _upcomingDengueOutbreakList.isNotEmpty; //Is the list empty?

  List<UpcomingDengueOutbreak> get upcomingDengueOutbreakList =>
      _upcomingDengueOutbreakList; //Return the upcoming dengue outbreak list

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  final logger = Logger();

  //UpcomingDengueOutbreak Creator
  Future<void> addUpcomingDengueOutbreak(
      double coordX,
      double coordY,
      Timestamp dateCreation,
      double humidity,
      double maxTemp,
      double minTemp,
      int predictEgg,
      int predictEggExtra,
      double windSpeed) async {
    try {
      Map<String, dynamic> upcomingDengueOutbreakData = {
        'coordX': coordX,
        'coordY': coordX,
        'dateCreation': dateCreation,
        'humidity': humidity,
        'maxTemp': maxTemp,
        'minTemp': minTemp,
        'predictEgg': predictEgg,
        'predictEggExtra': predictEggExtra,
        'windSpeed': windSpeed,
      };

      await dBaseRef
          .collection('UpcomingDengueOutbreak')
          .add(upcomingDengueOutbreakData)
          .then((querySnapshot) {
        UpcomingDengueOutbreak newUpcomingDengueOutbreak =
            UpcomingDengueOutbreak(
                querySnapshot.id.toString(),
                coordX,
                coordY,
                dateCreation,
                humidity,
                maxTemp,
                minTemp,
                predictEgg,
                predictEggExtra,
                windSpeed);
        _upcomingDengueOutbreakList.add(newUpcomingDengueOutbreak);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  //UpcomingDengueOutbreak Readers
  Future<List<UpcomingDengueOutbreak>> fetchAllUpcomingDengueOutbreak() async {
    try {
      _upcomingDengueOutbreakList.clear();
      _isFetchingUpcomingDengueOutbreak = true;

      QuerySnapshot querySnapshot =
          await dBaseRef.collection('UpcomingDengueOutbreak').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        UpcomingDengueOutbreak uDO = UpcomingDengueOutbreak(
          doc.id,
          data['coordX'] ?? 0.0,
          data['coordY'] ?? 0.0,
          data['dateCreation'] ?? Timestamp.now(),
          data['humidity'] ?? 0.0,
          data['maxTemp'] ?? 0.0,
          data['minTemp'] ?? 0.0,
          data['predictEgg'] ?? 0,
          data['predictEggExtra'] ?? 0,
          data['windSpeed'] ?? 0.0,
        );

        _upcomingDengueOutbreakList.add(uDO);
        logger.d(uDO);
      }
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingUpcomingDengueOutbreak = false;
      notifyListeners();
    }

    return _upcomingDengueOutbreakList;
  }

// UpcomingDengueOutbreak Deletor
  Future<void> deleteUpcomingDengueOutbreak(
      UpcomingDengueOutbreak delUDO) async {
    await dBaseRef
        .collection('UpcomingDengueOutbreak')
        .doc(delUDO.uDOID)
        .delete()
        .then((doc) => logger.d("Upcoming Dengue Outbreak deleted"),
            onError: (e) => logger.e("Error deleting document: $e"));

    _upcomingDengueOutbreakList.remove(delUDO);
    notifyListeners();
  }
}
