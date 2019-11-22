import 'dart:convert';

import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
import 'package:avid/services/auth.dart';
import 'package:avid/services/database.dart';
import 'package:avid/utils/card_view_post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Post/view_post_screen.dart';
import 'create_post_screen.dart';
import 'profile_screen.dart';


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
  User user;

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("user=${sharedPreferences.getString("user")}");
    user = User.fromJson(json.decode(sharedPreferences.getString("user")));
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getUserData();
  }

  ///------------------------------------------------  BuildWidget Section -------------------------------------///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        title: Text("Avid."),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: _signOut),
          IconButton(icon: Icon(Icons.person), onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ProfileScreen(user: user,)));
          }),

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
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      sharedPreferences.remove("user");
    } catch (e) {}
  }

  void _addPost() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                CreatePostScreen(
                  database: Database(),
                )));
  }


}
