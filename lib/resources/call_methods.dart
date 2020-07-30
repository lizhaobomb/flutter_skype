import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_skype/constants/strings.dart';
import 'package:flutter_skype/models/call.dart';
import 'package:flutter_skype/models/living.dart';

class CallMethods {
  final CollectionReference callCollection =
      Firestore.instance.collection(CALL_COLLECTION);
  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.document(uid).snapshots();

  final CollectionReference livingCollection =
      Firestore.instance.collection(LIVING_COLLECTION);
  Stream<DocumentSnapshot> livingStream({String uid}) =>
      livingCollection.document(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    // call.hasDialled = true;

    try {
      Map<String, dynamic> hasDialledMap = call.toMap(call);
      await callCollection.document(call.callerId).setData(hasDialledMap);
      await callCollection.document(call.receiverId).setData(hasDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.document(call.callerId).delete();
      await callCollection.document(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> makeLiving({Living living}) async {
    try {
      Map<String, dynamic> hasLivingMap = living.toMap(living);
      await livingCollection.document(living.callerId).setData(hasLivingMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endLiving({Living living}) async {
    try {
      await livingCollection.document(living.callerId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> fetchLivings({String userId}) {
    return livingCollection.snapshots();
  }  

  Future<List<Living>> fetchAllLivings({String userId}) async {
    List<Living> userList = List<Living>();

    QuerySnapshot querySnapshot =
        await livingCollection.getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != userId) {
        userList.add(Living.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }
}
