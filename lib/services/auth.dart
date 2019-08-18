import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<String> currentUser();
  Future<void> signOut();
  Future<void> createUsers({String userUid,String username,String fullName,String yourLocation,String email});
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user?.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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

  Future<void> createUsers({String userUid,String username,String fullName,String yourLocation,String email}){
   return databaseReference.child("Users").child("$userUid").set({
      'Username':'$username',
      'FullName':'$fullName',
      'YourLocation':'$yourLocation',
      'eamil':'$email',
    });
  }

}