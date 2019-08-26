import 'package:avid/services/auth.dart';
import 'package:avid/utils/style.dart';
import 'package:flutter/material.dart';

import 'signup_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({
    this.auth,
  });

  final BaseAuth auth;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ///------------------------------------------------  Parameters Section -------------------------------------///
  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //  For SnackBar
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  // Check  is valid or not
  bool _autoValidate = false;

  // To Save Email Here
  String _email;

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
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 80,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Expanded(flex: 4, child: _buildHeaderWidget()),
                Expanded(flex: 4, child: _buildBodyWidget()),
                Expanded(flex: 2, child: _buildTileWidget())
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///------------------------------------------------  Widget  Section -------------------------------------///
  Widget _buildHeaderWidget() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 45,
        ),
        Icon(
          Icons.lock,
          color: CColors.white,
          size: 47,
        ),
        SizedBox(
          height: 20,
        ),
        Text("Forgot password?",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18)),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45, right: 45),
          child: Text(
            "We just need your registered email address to send you password reset.",
            textWidthBasis: TextWidthBasis.parent,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff5e626c), fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _buildBodyWidget() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: <Widget>[
          ////////////////////////////
          ///   Email TextFiled   ///
          ////////////////////////////
          Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: TextFormField(
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
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: _validateAndSendForgotPassword,
            child: Text(
              "Reset Password",
              textAlign: TextAlign.center,
            ),
            color: Colors.white,
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
          )
        ],
      ),
    );
  }

  Widget _buildTileWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "DON'T HAVE AN ACCOUNT?",
          style: TextStyle(
              color: Color(0xff5e626c),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
        FlatButton(
          onPressed: _goToSignUpScreen,
          child: Text(
            "REGISTER",
            style: TextStyle(color: Colors.white),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  ///------------------------------------------------  Method  Section -------------------------------------///
  void _validateAndSendForgotPassword() async {
    if (_formKey.currentState.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      //todo when success

      try {
        await widget.auth.resetPassword(email: _email);
        _showSnackBarSuccess();
      } catch (e) {
        switch (e.code) {
          case 'ERROR_USER_NOT_FOUND':
            _scaffoldStateKey.currentState.showSnackBar(SnackBar(
              content: Text('User Not Found'),
              duration: Duration(milliseconds: 2000),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Sign Up',
                onPressed: () {
                  _goToSignUpScreen();
                },
                textColor: CColors.white,
              ),
            ));
            break;
        }
      }
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  /// Show Message when this SignUp is success
  _showSnackBarSuccess() {
    _formKey.currentState.reset();
    _scaffoldStateKey.currentState.showSnackBar(SnackBar(
      content: Text("Send Succesfuly"),
      backgroundColor: Colors.green,
    ));
  }

  void _goToSignUpScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SignUpScreen()));
  }
}
