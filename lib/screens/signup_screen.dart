import 'dart:async';
import 'dart:io';

import 'package:avid/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.auth, this.onSignedUp});

  final BaseAuth auth;
  final VoidCallback onSignedUp;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ///------------------------------------------------  Parameters Section -------------------------------------///
  int colorBackground = 0xff333333;
  TextStyle _styleTextFormFiled = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );
  InputBorder _borderTextFormFiled =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));

  // To Jump Next TextFormField Full Name
  FocusNode _fullNameFocus = FocusNode();

  // To Jump Next TextFormField Your Location
  FocusNode _yourLocationFocus = FocusNode();

  // To Jump Next TextFormField Email
  FocusNode _emailFocus = FocusNode();

  // To Jump Next TextFormField Password
  FocusNode _passwordFocus = FocusNode();

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //  For SnackBar
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  // Check  is valid or not
  bool _autoValidate = false;

  // Check  is agree or not
  bool _agreeTerms = false;

  // To Save Username Here
  String _username;

  // To Save Full Name Here
  String _fullName;

  // To Save Your Location Here
  String _yourLocation;

  // To Save Email Here
  String _email;

  // To Save Your Password Here
  String _password;

  File _imageProfile;

  ///------------------------------------------------  BuildWidget Section -------------------------------------///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        backgroundColor: Color(colorBackground),
      ),
      backgroundColor: Color(colorBackground),
      body: ListView(
        children: <Widget>[
          buildHeaderTitle(),
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
              InkWell(
                onTap: getImage,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: _imageProfile == null
                              ? EdgeInsets.all(15)
                              : EdgeInsets.all(10),
                          child: _imageProfile == null
                              ? Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Image.file(_imageProfile,
                                  height: 60, width: 60, fit: BoxFit.cover),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: Colors.white))),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: _imageProfile == null
                              ? Text(
                                  "Please attach your image to set as profile picture.",
                                  style: _styleTextFormFiled,
                                )
                              : Text(
                                  "Profile Image Selected",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 22),
                                  textAlign: TextAlign.center,
                                ),
                        )),
                      ],
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              ///////////////////////////////
              ///   Username TextFiled   ///
              /////////////////////////////
              TextFormField(
                onSaved: (username) {
                  _username = username;
                },
                validator: (username) {
                  if (username.length == 0)
                    return 'Must Not Empty!';
                  else
                    return null;
                },
                decoration: InputDecoration(
                  focusedBorder: _borderTextFormFiled,
                  enabledBorder: _borderTextFormFiled,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  labelText: 'Username',
                  labelStyle: _styleTextFormFiled,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  FocusScope.of(context).requestFocus(_fullNameFocus);
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              ////////////////////////////////
              ///   Full Name TextFiled   ///
              //////////////////////////////
              TextFormField(
                focusNode: _fullNameFocus,
                onSaved: (fullName) {
                  _fullName = fullName;
                },
                validator: (fullName) {
                  if (fullName.length == 0)
                    return 'Must Not Empty!';
                  else
                    return null;
                },
                decoration: InputDecoration(
                  focusedBorder: _borderTextFormFiled,
                  enabledBorder: _borderTextFormFiled,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.format_color_text,
                    color: Colors.white,
                  ),
                  labelText: 'Full Name',
                  labelStyle: _styleTextFormFiled,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  FocusScope.of(context).requestFocus(_yourLocationFocus);
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              ////////////////////////////////////
              ///   Your Location TextFiled   ///
              //////////////////////////////////
              TextFormField(
                focusNode: _yourLocationFocus,
                onSaved: (yourLocation) {
                  _yourLocation = yourLocation;
                },
                validator: (yourLocation) {
                  if (yourLocation.length == 0)
                    return 'Must Not Empty!';
                  else
                    return null;
                },
                maxLines: 2,
                decoration: InputDecoration(
                  focusedBorder: _borderTextFormFiled,
                  enabledBorder: _borderTextFormFiled,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  labelText: 'Your Location',
                  labelStyle: _styleTextFormFiled,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              ///////////////////////////////
              ///   Email TextFiled   ///
              /////////////////////////////
              TextFormField(
                focusNode: _emailFocus,
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
                  focusedBorder: _borderTextFormFiled,
                  enabledBorder: _borderTextFormFiled,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.white,
                  ),
                  labelText: 'Email',
                  labelStyle: _styleTextFormFiled,
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
                  focusedBorder: _borderTextFormFiled,
                  enabledBorder: _borderTextFormFiled,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                  ),
                  labelText: 'Password',
                  labelStyle: _styleTextFormFiled,
                ),
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    child: buildAgreeTerms(),
                  ),
                  buildSignUpButton(),
                  SizedBox(
                    height: 35,
                    child: buildAlreadyHaveAccount(),
                  ),
                ],
              )
            ],
          )),
    );
  }

  ///--------------------------
  ///      Header Title
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
                "Join avid.",
                style: TextStyle(fontSize: 30, color: Colors.white),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome, we are happy that you are here!",
                style: TextStyle(fontSize: 15, color: Colors.white),
              )),
        ],
      ),
    );
  }

  ///--------------------------
  ///   Agree Terms Check
  /// ------------------------
  Widget buildAgreeTerms() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: _agreeTerms,
          onChanged: (v) {
            setState(() {
              _agreeTerms = v;
            });
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {},
            child: Text(
              "I Agree With Terms Of Service",
              style: TextStyle(color: Colors.white, fontSize: 12),
            )),
      ],
    );
  }

  ///--------------------------
  ///      SignUp Button
  /// ------------------------
  Widget buildSignUpButton() {
    return RaisedButton(
      onPressed: _validateInputs,
      child: Text(
        "Sign Up",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
      color: Colors.white,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      padding: EdgeInsets.only(left: 100, right: 100, top: 15, bottom: 15),
    );
  }

  ///--------------------------
  ///   Already Have Account
  /// ------------------------
  Widget buildAlreadyHaveAccount() {
    return FlatButton(
        onPressed: () {
          goToSignIn();
        },
        child: Text(
          "Already have an account?? Log In",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ));
  }

  ///------------------------------------------------  Method  Section -------------------------------------///
  Future _validateInputs() async {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      if (_agreeTerms == true) {
        //If Sign Up Successfully
        signUp();
      } else {
        // If user not Agree Terms
        showSnackBarNotAgreeTerms();
      }
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  signUp() async {
    try {
      String user =
          await widget.auth.createUserWithEmailAndPassword(_email, _password);
      if (user != null) {
        try {
          widget.auth.createUsers(
            profilePicture: _imageProfile,
              userUid: user,
              username: _username,
              fullName: _fullName,
              yourLocation: _yourLocation,
              email: _email);
          resetDefault();
          Timer(Duration(milliseconds: 1000), () {
            goToSignIn();
          });
          showSnackBarSuccess();
        } catch (e) {
          print("erooooooor======$e");
        }
      }
    } catch (e) {
      validateFireBaseError(e);
    }
  }

  validateFireBaseError(e) {
    switch (e.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        _scaffoldStateKey.currentState.showSnackBar(SnackBar(
          content: Text("Email Already In Use"),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
        ));
        break;
    }
  }

  /// Show Error message when not agree with terms
  showSnackBarNotAgreeTerms() {
    SnackBar snackBar = SnackBar(
      content: Text("Agree With Terms First"),
      backgroundColor: Colors.red,
      duration: Duration(milliseconds: 1000),
    );
    _scaffoldStateKey.currentState.showSnackBar(snackBar);
  }

  /// Show Message when this SignUp is success
  showSnackBarSuccess() {
    _scaffoldStateKey.currentState.showSnackBar(SnackBar(
      content: Text("Sign Up Succesfuly"),
      backgroundColor: Colors.green,
    ));
  }

  /// Reset All Filed to Empty
  resetDefault() {
    widget.auth.signOut();
    widget.onSignedUp();
    _formKey.currentState.reset();
    setState(() {
      _agreeTerms = false;
    });
  }

  /// Go To Sign In Screen
  goToSignIn() {
    Navigator.of(context).pop();
  }

  /// get Image from device
  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    setState(() {
      _imageProfile = image;
    });
  }
}
