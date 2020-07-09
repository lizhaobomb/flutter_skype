import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_skype/models/message.dart';
import 'package:flutter_skype/models/user.dart';
import 'package:flutter_skype/provider/image_upload_provider.dart';
import 'package:flutter_skype/resources/auth_methods.dart';
import 'package:flutter_skype/resources/chat_methods.dart';
import 'package:flutter_skype/resources/firebase_methods.dart';
import 'package:flutter_skype/resources/storage_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  AuthMethods _authMethods = AuthMethods();
  ChatMethods _chatMethods = ChatMethods();
  StorageMethods _storageMethods = StorageMethods();

  Future<FirebaseUser> getCurrentUser() => _authMethods.getCurrentUser();
  Future<User> getUserDetails() => _authMethods.getUserDetails();
  Future<FirebaseUser> signIn() => _authMethods.signIn();
  Future<bool> authenticateUser(FirebaseUser user) =>
      _authMethods.authenticateUser(user);
  Future<void> addDataToDb(FirebaseUser user) =>
      _firebaseMethods.addDataToDb(user);
  Future<void> signOut() => _authMethods.signOut();
  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) =>
      _firebaseMethods.fetchAllUsers(currentUser);

  Future<void> addMessageToDb(Message message, User sender, User receiver) =>
      _chatMethods.addMessageToDb(message, sender, receiver);

  void uploadImage(
          {@required File image,
          @required String receiverId,
          @required String senderId,
          @required ImageUploadProvider imageUploadProvider}) =>
      _storageMethods.uploadImage(
          image, receiverId, senderId, imageUploadProvider);
}
