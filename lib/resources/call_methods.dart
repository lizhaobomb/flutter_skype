import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_skype/constants/strings.dart';
import 'package:flutter_skype/models/call.dart';

class CallMethods {
  final CollectionReference callCollection =
      Firestore.instance.collection(CALL_COLLECTION);
  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.document(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    call.hasDialled = true;

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
}
