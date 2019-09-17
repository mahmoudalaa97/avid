import 'dart:convert';

import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
import 'package:avid/services/database.dart';
import 'package:avid/utils/card_view_post.dart';
import 'package:avid/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../search_location_screen.dart';

class ViewPostScreen extends StatefulWidget {
  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  Database database = Database();
  final keySharePrefrance = 'recentSearch';

  // To Save Your Location Here
  String _yourCityText;
  var value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPostViewWidget();
  }

  Widget _buildPostViewWidget() {
    return Column(
      children: <Widget>[
        _buildSearchAndSort(),
        Flexible(
            child: StreamBuilder(
              stream: database.getPost(),
              builder:
                  (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshott) {
                if (snapshott.hasError)
                  return new Text('Error: ${snapshott.error}');
                if (snapshott.hasData) {
                  return new ListView.builder(
                    itemCount: snapshott.data.documents.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<DocumentSnapshot>(
                        stream: database.getUserOfPost(
                            snapshott.data.documents[index]["UserId"]),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          if (snapshot.hasData) {
                            User user = User.fromDocument(snapshot.data);
                            Post post = Post.fromDocumentJson(
                                snapshott.data.documents[index]);
                            return CardViewPost(
                              post: post,
                              index: index,
                              user: user,
                            );
                          } else
                            return Center(child: Container(),);
                        },
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator(),);
              },
            ))
      ],
    );
  }


//  _childAdded(Event event) {
//    _referenceUser
//        .child(event.snapshot.value['UserId'])
//        .once()
//        .then((snapshot) {
//      setState(() {
//        Post post = Post.fromSnapshotJson(event.snapshot);
//        post.user = User.fromSnapshotJson(snapshot);
//        postsList.add(post);
//      });
//    });
//  }

  ///[Deprecated]
//
//  void _childRemoves(Event event) {
//    var deletedPost = postsList.singleWhere((post) {
//      return post.key == event.snapshot.key;
//    });
//
//    setState(() {
//      postsList.removeAt(postsList.indexOf(deletedPost));
//    });
//  }
  ///[Deprecated]
//  void _childChanged(Event event) {
//    print(event.snapshot.value);
//    var changedPost = postsList.singleWhere((post) {
//      return post.key == event.snapshot.key;
//    });
//
//    _referenceUser
//        .child(event.snapshot.value['UserId'])
//        .once()
//        .then((snapshot) {
//      print(snapshot.value);
//      setState(() {
//        Post post = Post.fromSnapshotJson(event.snapshot);
//        post.user = User.fromSnapshotJson(snapshot);
//        postsList[postsList.indexOf(changedPost)] = post;
//      });
//    });
//  }

  _buildSearchAndSort() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
      margin: EdgeInsets.only(top: 3),
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 15, bottom: 10, right: 35),
        height: 110,
        width: MediaQuery
            .of(context)
            .size
            .width,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  _yourCityText == null
                      ? value == null ? "Select Place" : "$value."
                      : "$_yourCityText.",
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 20, left: 10),
                    child: InkWell(
                        onTap: () async {
                          final selected = await showSearch(
                              context: context,
                              delegate: SearchLocationScreen());
                          print(selected);
                          setState(() {
                            if (selected.isNotEmpty) {
                              _yourCityText = jsonDecode(selected)['Title'];
                            }
                          });
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        )))
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "10 Seller. Listings.",
                  style: TextStyle(fontSize: 12),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                          onTap: () {},
                          child: Text("Most Recent",
                              style: TextStyle(fontSize: 12))),
                      InkWell(
                          onTap: () {},
                          child:
                          Text("Sort By", style: TextStyle(fontSize: 12))),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
