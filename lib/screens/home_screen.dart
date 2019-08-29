import 'package:avid/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'create_post_screen.dart';
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(colorBackground),
        title: Text("Avid."),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: _signOut)
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        child: Icon(Icons.add),
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

  void _addPost() {
    Navigator.push(_scaffoldKey.currentContext, MaterialPageRoute(builder: (_)=>CreatePostScreen()));
  }
}
