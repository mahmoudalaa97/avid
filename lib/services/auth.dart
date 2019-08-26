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
      String yourCity,
      String yourState,
      String email});

  Future<void> resetPassword({String email});
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

  @override
  Future<void> createUsers(
      {File profilePicture,
      String userUid,
      String username,
      String fullName,
      String yourCity,
      String yourState,
      String email}) async {
    if (profilePicture != null) {
      var pathProfilePicture = 'UsersProfilePicture/$userUid' + '.jpg';
      StorageReference reference =
          FirebaseStorage.instance.ref().child(pathProfilePicture);
      final task = reference.putFile(profilePicture);
      //TODO check for image upload or not Using #task
      var nameOfPicture =
          profilePicture == null ? 'default.png' : userUid + '.jpg';
      var fullPathProfilePicture =
          'https://firebasestorage.googleapis.com/v0/b/avid-d7792.appspot.com/o/UsersProfilePicture%2F$nameOfPicture?alt=media';
      return databaseReference.child("Users").child("$userUid").set({
        'Username': '$username',
        'FullName': '$fullName',
        'YourLocation': {'City': '$yourCity', 'State': '$yourState'},
        'eamil': '$email',
        'profilePiture': '$fullPathProfilePicture'
      });
    }
  }

  @override
  Future<void> resetPassword({String email}) async {
   await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
