import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/cup.dart';
import 'package:desapv3/models/ovitrap.dart';
import 'package:desapv3/reuseable_widget/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class DataController with ChangeNotifier {
  final List<Ovitrap> _oviTrapList = [];
  final List<Cup> _cupList = [];

  bool _isFetchingOviTraps = false;
  bool _isFetchingCups = false;

  bool get isOviTrapLoaded => _oviTrapList.isNotEmpty;
  List<Ovitrap> get oviTrapList => _oviTrapList;
  List<Cup> get cupList => _cupList;
  bool get isFetchingOviTraps => _isFetchingOviTraps;
  bool get isFetchingCups => _isFetchingCups;

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  final logger = Logger();

  //Creaters
  Future<void> addOvitrap(
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
        Ovitrap newOviTrap = Ovitrap(
            querySnapshot.id.toString(),
            location,
            member,
            status,
            epiWeekInstl,
            epiWeekRmv,
            instlTime,
            removeTime,
            '');
        _oviTrapList.add(newOviTrap);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  //Readers
  Future<List<Ovitrap>> fetchOviTraps() async {
    try {
      _oviTrapList.clear();
      _isFetchingOviTraps = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await dBaseRef.collection('OviTrap').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        logger.d(data);

        Ovitrap ovitrap = Ovitrap(
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
            data['cupID'] ?? '');

        logger.d(ovitrap.instlTime);

        _oviTrapList.add(ovitrap);
        logger.d(ovitrap);
      }

      notifyListeners();
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingOviTraps = false;
      notifyListeners();
    }

    return _oviTrapList;
  }

  //Updater
  Future<void> updateOvitrap(Ovitrap newOTrap, int index) async {
    try {
      // Map<String, dynamic> newOviTrapData = {
      //   'location': newOTrap.location,
      //   'member': newOTrap.member,
      //   'status': newOTrap.status,
      //   'epiWeekInstl': newOTrap.epiWeekInstl,
      //   'epiWeekRmv': newOTrap.epiWeekRmv,
      //   'instlTime': newOTrap.instlTime,
      //   'removeTime': newOTrap.removeTime,
      //   'cupID': newOTrap.cupID,
      // };

      // Update in Firestore
      await dBaseRef.collection('OviTrap').doc(newOTrap.oviTrapID).update({
        'location': newOTrap.location,
        'member': newOTrap.member,
        'status': newOTrap.status,
        'epiWeekInstl': newOTrap.epiWeekInstl,
        'epiWeekRmv': newOTrap.epiWeekRmv,
        'instlTime': newOTrap.instlTime,
        'removeTime': newOTrap.removeTime,
        'cupID': newOTrap.cupID,
      });

      // Optionally fetch updated data or directly add the new object to the list
      _oviTrapList.update(index, newOTrap);
      notifyListeners();
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  Future<void> deleteOvitrap(Ovitrap newOTrap) async {
    await dBaseRef.collection('OviTrap').doc(newOTrap.oviTrapID).delete().then(
        (doc) => logger.d("Document deleted"),
        onError: (e) => logger.e("Error deleting document: $e"));

    _oviTrapList.remove(newOTrap);
  }

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
            data['status'] ?? '');

        _cupList.add(cup);
        notifyListeners();
        logger.d(cup.cupID);
      }
    } catch (e) {
      logger.e("Error");
      rethrow;
    }

    return _cupList;
  }
}
