import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_skype/constants/strings.dart';
import 'package:flutter_skype/enum/user_state.dart';
import 'package:flutter_skype/models/user.dart';
import 'package:flutter_skype/utils/utilities.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  static final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<User> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapShot =
          await _userCollection.document(id).get();
      return User.fromMap(documentSnapShot.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();
    return User.fromMap(documentSnapshot.data);
  }

  Future<FirebaseUser> signIn() async {
    print("Future<FirebaseUser> signIn() async");
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);
    AuthResult result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);
    _userCollection.document(userId).updateData({"state": stateNum});
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) {
    return _userCollection.document(uid).snapshots();
  }
}
