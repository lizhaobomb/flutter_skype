import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_skype/models/message.dart';
import 'package:flutter_skype/models/user.dart';
import 'package:flutter_skype/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  

  Future<FirebaseUser> getCurrentUser() => _firebaseMethods.getCurrentUser();
  Future<FirebaseUser> signIn() => _firebaseMethods.signIn();
  Future<bool> authenticateUser(FirebaseUser user) => _firebaseMethods.authenticateUser(user);
  Future<void> addDataToDb(FirebaseUser user) => _firebaseMethods.addDataToDb(user);
  Future<void> signOut() => _firebaseMethods.signOut();
  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) => _firebaseMethods.fetchAllUsers(currentUser);

  Future<void> addMessageToDb(Message message, User sender, User receiver) => _firebaseMethods.addMessageToDb(message, sender, receiver);
}