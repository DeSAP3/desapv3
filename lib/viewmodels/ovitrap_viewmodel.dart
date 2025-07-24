import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/models/ovitrap.dart';
import 'package:desapv3/reuseable_widget/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class OvitrapViewModel with ChangeNotifier {
  final List<OviTrap> _oviTrapList = [];

  bool _isFetchingOviTrap = false; //Is an ovitrap fetching in progress?

  bool get isFetchingOviTrap => _isFetchingOviTrap; //Get the status of the fetching progress

  bool get isOviTrapLoaded => _oviTrapList.isNotEmpty; //Is the list empty?

  List<OviTrap> get oviTrapList => _oviTrapList; //Return the ovitrap list

  FirebaseFirestore dBaseRef = FirebaseFirestore.instance;

  final logger = Logger();

  //Ovitrap Creators
  Future<void> addOviTrap(
      String location,
      String member,
      String status,
      int epiWeekInstl,
      int epiWeekRmv,
      Timestamp instlTime,
      Timestamp removeTime,
      String dengueCaseID) async {
    try {
      Map<String, dynamic> ovitrapData = {
        'location': location,
        'member': member,
        'status': status,
        'epiWeekInstl': epiWeekInstl,
        'epiWeekRmv': epiWeekRmv,
        'instlTime': instlTime,
        'removeTime': removeTime,
        'dengueCaseID': dengueCaseID
      };

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
            removeTime,
            dengueCaseID);
        _oviTrapList.add(newOviTrap);
        notifyListeners();
      });
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  //Ovitrap Readers
  Future<List<OviTrap>> fetchOviTrap() async {
    try {
      _oviTrapList.clear();
      _isFetchingOviTrap = true;

      QuerySnapshot querySnapshot = await dBaseRef.collection('OviTrap').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; //toJson

        OviTrap ovitrap = OviTrap(
            doc.id,
            data['location'] ?? '',
            data['member'] ?? '',
            data['status'] ?? '',
            data['epiWeekInstl'] ?? 0,
            data['epiWeekRmv'] ?? 0,
            (data['instlTime'] as Timestamp?) ?? Timestamp.now(),
            (data['removeTime'] as Timestamp?) ?? Timestamp.now(),
            data['dengueCaseID'] ?? '');

        _oviTrapList.add(ovitrap);
        logger.d(ovitrap);
      }
    } on FirebaseException catch (e) {
      logger.e(e.message);
      rethrow;
    } finally {
      _isFetchingOviTrap = false;
      notifyListeners();
    }

    return _oviTrapList;
  }

  //Ovitrap Updater
  Future<void> updateOviTrap(OviTrap newOviTrap, int index) async {
    try {
      await dBaseRef.collection('OviTrap').doc(newOviTrap.oviTrapID).update({
        'location': newOviTrap.location,
        'member': newOviTrap.member,
        'status': newOviTrap.status,
        'epiWeekInstl': newOviTrap.epiWeekInstl,
        'epiWeekRmv': newOviTrap.epiWeekRmv,
        'instlTime': newOviTrap.instlTime,
        'removeTime': newOviTrap.removeTime,
      });

      _oviTrapList.update(index, newOviTrap);
      notifyListeners();
    } catch (e) {
      logger.e('Error adding Ovitrap: ${e.toString()}');
    }
  }

  //Ovitrap Deletor
  Future<void> deleteOviTrap(OviTrap delOviTrap) async {
    await dBaseRef
        .collection('OviTrap')
        .doc(delOviTrap.oviTrapID)
        .delete()
        .then((doc) => logger.d("Ovitrap deleted"),
            onError: (e) => logger.e("Error deleting document: $e"));

    _oviTrapList.remove(delOviTrap);
    notifyListeners();
  }
}
