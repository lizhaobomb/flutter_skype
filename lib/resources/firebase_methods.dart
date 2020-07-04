
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_skype/constants/strings.dart';
import 'package:flutter_skype/models/message.dart';
import 'package:flutter_skype/models/user.dart';
import 'package:flutter_skype/provider/image_upload_provider.dart';
import 'package:flutter_skype/utils/utilities.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;
  StorageReference _storageReference;
  static final CollectionReference _userCollection = firestore.collection(USERS_COLLECTION);
  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
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
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);
    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username);

    await firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await firestore.collection("users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();
    await firestore
        .collection("messages")
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    return await firestore
        .collection("messages")
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;
    _message = Message.imageMessage(
      message: "IMAGE",
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: "image",
    );

    var map = _message.toImageMap();
    // set the data to database
    await firestore
        .collection("messages")
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await firestore
        .collection("messages")
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    setImageMsg(url, receiverId, senderId);
  }
}
