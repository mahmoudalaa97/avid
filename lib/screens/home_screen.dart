import 'package:avid/model/Post.dart';
import 'package:avid/services/auth.dart';
import 'package:avid/services/database.dart';
import 'package:avid/utils/card_view_post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'Post/view_post_screen.dart';
import 'create_post_screen.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  ///------------------------------------------------  Parameters Section -------------------------------------///
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final BaseDatabase database;

  const HomeScreen({this.auth, this.onSignedOut, this.database});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///------------------------------------------------  BuildWidget Section -------------------------------------///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffFBF9F9),
      appBar: AppBar(
        title: Text("Avid."),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: _signOut)
        ],
      ),
      body: ViewPostScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        child: Icon(Icons.add),
      ),
    );
  }

  ///------------------------------------------------  Method  Section -------------------------------------///
  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {}
  }

  void _addPost() {
    Navigator.push(
        _scaffoldKey.currentContext,
        MaterialPageRoute(
            builder: (_) =>
                CreatePostScreen(
                  database: Database(),
                )));
  }
}
