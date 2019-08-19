import 'package:avid/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  ///------------------------------------------------  Parameters Section -------------------------------------///
  // black Color For BackGround
  final int colorBackground = 0xff333333;
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  const HomeScreen({this.auth, this.onSignedOut});

  ///------------------------------------------------  BuildWidget Section -------------------------------------///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(colorBackground),
        title: Text("Avid."),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome to home screen"),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: _signOut,
            )
          ],
        ),
      ),
    );
  }

  ///------------------------------------------------  Method  Section -------------------------------------///
  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {}
  }
}
