import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<String> currentUser();

  Future<void> signOut();

  Future<void> createUsers(
      {File profilePicture,
      String userUid,
      String username,
      String fullName,
      String yourLocation,
      String email});
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user?.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }

  @override
  Future<String> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> createUsers(
      {File profilePicture,
      String userUid,
      String username,
      String fullName,
      String yourLocation,
      String email}) {
    var pathProfilePicture;
    profilePicture != null
        ? pathProfilePicture = 'UsersProfilePicture/$userUid' + '.jpg'
        : pathProfilePicture = 'UsersProfilePicture/default' + '.jpg';
    StorageReference reference =
        FirebaseStorage.instance.ref().child(pathProfilePicture);
    final StorageUploadTask task = reference.putFile(profilePicture);
    var fullPathProfilePicture =
        'https://firebasestorage.googleapis.com/v0/b/avid-d7792.appspot.com/o/UsersProfilePicture%2F$userUid.jpg?alt=media';
    return databaseReference.child("Users").child("$userUid").set({
      'Username': '$username',
      'FullName': '$fullName',
      'YourLocation': '$yourLocation',
      'eamil': '$email',
      'profilePiture': '$fullPathProfilePicture'
    });
  }
}
