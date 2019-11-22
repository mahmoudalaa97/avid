import 'dart:convert';

import 'package:avid/model/User.dart';
import 'package:avid/services/database.dart';
import 'package:avid/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth, this.onSignedIn, this.onSignedUp});

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final VoidCallback onSignedUp;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ///------------------------------------------------  Parameters Section -------------------------------------///

  // To Jump Next TextFormField Password
  FocusNode _passwordFocus = FocusNode();

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //  For SnackBar
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  // Check  is valid or not
  bool _autoValidate = false;

  // To Save Email Here
  String _email;

  // To Save Your Password Here
  String _password;

  ///------------------------------------------------  BuildWidget Section -------------------------------------///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        backgroundColor: CColors.colorBackground,
      ),
      backgroundColor: CColors.colorBackground,
      body: ListView(
        children: <Widget>[
          buildHeaderTitle(),
          SizedBox(
            height: 90,
          ),
          buildFormUi(),
        ],
      ),
    );
  }

  ///------------------------------------------------  Widget Section -------------------------------------///

  ///--------------------------
  ///      Build Form UI
  /// ------------------------
  Widget buildFormUi() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              ////////////////////////////
              ///   Email TextFiled   ///
              ////////////////////////////
              TextFormField(
                onSaved: (email) {
                  _email = email;
                },
                validator: (email) {
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(email)) return 'Enter Valid Email';
                  if (email.length == 0)
                    return 'Must Not Empty!';
                  else
                    return null;
                },
                decoration: InputDecoration(
                  focusedBorder: Style.borderTextFormFiled,
                  enabledBorder: Style.borderTextFormFiled,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  labelText: 'Email',
                  labelStyle: Style.styleTextFormFiled,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              ////////////////////////////
              ///  Password TextFiled  ///
              ////////////////////////////
              TextFormField(
                obscureText: true,
                focusNode: _passwordFocus,
                onSaved: (password) {
                  _password = password;
                },
                validator: (password) {
                  if (password.length < 6) {
                    return "password must be 6 or more";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  focusedBorder: Style.borderTextFormFiled,
                  enabledBorder: Style.borderTextFormFiled,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                  ),
                  labelText: 'Password',
                  labelStyle: Style.styleTextFormFiled,
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    child: buildForgotPassword(),
                  ),
                  buildLoginButton(),
                  SizedBox(
                    height: 35,
                    child: buildFirstTimeHere(),
                  ),
                ],
              )
            ],
          )),
    );
  }

  ///--------------------------
  ///     Header Title
  /// ------------------------
  Widget buildHeaderTitle() {
    return Container(
      margin: EdgeInsets.all(15),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Log In",
                style: TextStyle(fontSize: 30, color: Colors.white),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome, we are happy that you are back!",
                style: TextStyle(fontSize: 15, color: Colors.white),
              )),
        ],
      ),
    );
  }

  ///--------------------------
  ///  Forgot Password Screen
  /// ------------------------
  Widget buildForgotPassword() {
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ForgotPasswordScreen(
                    auth: Auth(),
                  )));
        },
        child: Text(
          "FORGOT LOG IN ?",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ));
  }

  ///--------------------------
  ///      Login Button
  /// ------------------------
  Widget buildLoginButton() {
    return RaisedButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          // If all data are correct then save data to out variables
          _formKey.currentState.save();
          validateFireBaseError();
        } else {
          // If all data are not valid then start auto validation.
          setState(() {
            _autoValidate = true;
          });
        }
      },
      child: Text(
        "LOG IN",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      color: Colors.white,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      padding: EdgeInsets.only(left: 100, right: 100, top: 15, bottom: 15),
    );
  }

  ///--------------------------
  ///    First Time Here
  /// ------------------------
  Widget buildFirstTimeHere() {
    return FlatButton(
        onPressed: () {
          goToSignUpScreen();
        },
        child: Text(
          "First time here?? Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ));
  }

  ///------------------------------------------------  Method  Section -------------------------------------///
  goToSignUpScreen() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignUpScreen(
          auth: widget.auth,
          onSignedUp: widget.onSignedUp,
        )));
    _formKey.currentState.reset();
    setState(() {
      _autoValidate = false;
    });
  }

  /// Sign In and handel Error
  signIn() {
    return widget.auth.signInWithEmailAndPassword(_email, _password);
  }

  validateFireBaseError() async {
    showDialog(context: context, builder: (_) =>
        AlertDialog(content: Container(
            height: 50,
            child: Center(child: CircularProgressIndicator(),)),));
    try {
      String user =
      await widget.auth.signInWithEmailAndPassword(_email, _password);
      if (user != null) {
        bool saved = await saveUserData();
        if (saved) {
          widget.onSignedIn();
          Navigator.of(context, rootNavigator: true).pop('dialog');
        }
      }
    } catch (e) {
      print(e);
      switch (e.code) {
        case 'ERROR_NETWORK_REQUEST_FAILED':
          _scaffoldStateKey.currentState.showSnackBar(SnackBar(
            content: Text("Check Network"),
            action: SnackBarAction(
              label: "Fix",
              onPressed: () {},
              textColor: Colors.greenAccent,
            ),
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.blueGrey,
          ));
          break;
        case 'ERROR_WRONG_PASSWORD':
          _scaffoldStateKey.currentState.showSnackBar(SnackBar(
            content: Text("Cheack Email or Password"),
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.red,
          ));
          break;
        case 'ERROR_USER_NOT_FOUND':
          _scaffoldStateKey.currentState.showSnackBar(SnackBar(
            content: Text('User Not Found'),
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Sign Up',
              onPressed: () {
                goToSignUpScreen();
              },
              textColor: CColors.white,
            ),
          ));
          break;
      }
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }

  Future<bool> saveUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    BaseDatabase database = Database();
    User users = await database.getCurrentUser();
    String user = jsonEncode(users.toJson());
    return sharedPreferences.setString("user", user);
  }
}
