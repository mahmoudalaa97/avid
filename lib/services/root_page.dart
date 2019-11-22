import 'dart:convert';

import 'package:avid/model/User.dart';
import 'package:avid/screens/home_screen.dart';
import 'package:avid/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';
import 'database.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    },onError: (e){
      print("error=${e.runtimeType}");
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() async {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  void _signedUp(){
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  Future<bool> saveUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    BaseDatabase database = Database();
    User users = await database.getCurrentUser();
    String user = jsonEncode(users.toJson());

    return sharedPreferences.setString("user", user);
//    BaseAuth auth =Auth();
//    auth.currentUser().then((userId){
//      saved= sharedPreferences.setString("userId", userId);
//    });

  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return LoginScreen(
          auth: widget.auth,
          onSignedIn: _signedIn,
          onSignedUp: _signedUp,
        );
      case AuthStatus.signedIn:
        saveUserData();
        return HomeScreen(
          auth: widget.auth,
          onSignedOut: _signedOut,
          database: Database(),
        );
      default:
        return Container();
    }
  }
}
