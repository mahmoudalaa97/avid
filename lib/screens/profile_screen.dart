import 'dart:convert';

import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
import 'package:avid/services/database.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BaseDatabase database = Database();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AppBar(
            titleSpacing: 1,
            elevation: 5,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.profilePicture),
                      backgroundColor: Colors.white,
                      radius: 22,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "${widget.user.username}",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 10,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${widget.user.yourLocation.city}, ${widget.user.yourLocation.state}",
                              style: TextStyle(fontSize: 11),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.dashboard), onPressed: () {})
            ],
          ),
          Expanded(child: _streamDefault()),
        ],
      ),
    );
  }

  Widget _streamDefault() {
    return StreamBuilder(
      stream: database.getUserPost(widget.user.userUid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshott) {
        if (snapshott.hasError) return new Text('Error: ${snapshott.error}');
        if (snapshott.hasData) {
          if (snapshott.data.documents.length == 0) {
            return Image.asset(
              "assets/emptyPost.png",
              fit: BoxFit.contain,
            );
          }
          return new ListView.builder(
            itemCount: snapshott.data.documents.length,
            itemBuilder: (context, index) {
              return StreamBuilder<DocumentSnapshot>(
                stream: database
                    .getUserOfPost(snapshott.data.documents[index]["UserId"]),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  if (snapshot.hasData) {
                    User user = User.fromDocument(snapshot.data);
                    Post post =
                        Post.fromDocumentJson(snapshott.data.documents[index]);
                    return CardPost(
                      post: post,
                      user: user,
                    );
                  } else
                    return Center(
                      child: Container(),
                    );
                },
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CardPost extends StatelessWidget {
  final Post post;
  final User user;

  CardPost({Key key, this.post, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int differenceMinutes =
        DateTime.now().difference(post.dateTime.toDate()).inMinutes;
    int differenceHours =
        DateTime.now().difference(post.dateTime.toDate()).inHours;
    int differenceDays =
        DateTime.now().difference(post.dateTime.toDate()).inDays;
    TextStyle _textStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 11);
    return Card(
      shape: RoundedRectangleBorder(),
      child: Container(
        height: 130,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 130,
              width: 130,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Image.network(
                        post.details.pictures[0] ?? "Http://Google.com",
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                    top: 1,
                    left: 1,
                    child: _buildCardTag(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 8, top: 10, right: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("${user.username}"),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post.dateTime != null
                              ? differenceMinutes < 60
                                  ? "$differenceMinutes Minutes"
                                  : differenceMinutes >= 60 &&
                                          differenceMinutes < 1440
                                      ? "$differenceHours Hours"
                                      : differenceMinutes >= 1440 &&
                                              differenceMinutes <= 40320
                                          ? "$differenceDays Days"
                                          : "${differenceDays ~/ 28} Months"
                              : "",
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.location_on,
                          size: 10,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${post.location.city}, ${post.location.state}",
                          style: TextStyle(fontSize: 11),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    post.details.price != null
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: int.parse(post.details.price) >= 999
                                ? Text(
                                    "\$ ${int.parse(post.details.price) / 1000}k asking price",
                                  )
                                : Text(
                                    "\$ ${post.details.price} asking price",
                                  ))
                        : Container(height: 0, width: 0),
                    SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 0,
                      children: <Widget>[
                        Visibility(
                          visible: post.propertyType != null,
                          child: Text(
                            "${post.propertyType}  ",
                            style: _textStyle,
                          ),
                        ),
                        Visibility(
                          visible: post.turnkeyListing != null,
                          child: Text(
                            "Turnkey Listing  ",
                            style: _textStyle,
                          ),
                        ),
                        Visibility(
                          visible: post.listingType != null,
                          child: Text(
                            "${post.listingType}  ",
                            style: _textStyle,
                          ),
                        ),
                        Visibility(
                          visible: post.joinVentureType != null,
                          child: Text(
                            "${post.joinVentureType}  ",
                            style: _textStyle,
                          ),
                        ),
                        Visibility(
                          visible: post.bringMeADeal != null,
                          child: Text(
                            "Bring Me A Deal  ",
                            style: _textStyle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 0,
                      runSpacing: 5,
                      children: <Widget>[
                        post.details.bedRoom != null
                            ? Text(
                                "${post.details.bedRoom} bd  ",
                                style: _textStyle,
                              )
                            : Container(height: 0, width: 0),
                        post.details.bathRoom != null
                            ? Text(
                                "${post.details.bathRoom}ba  ",
                                style: _textStyle,
                              )
                            : Container(height: 0, width: 0),
                        post.details.squareFootage != null
                            ? Text(
                                "${int.parse(post.details.squareFootage) > 999 ? "${int.parse(post.details.squareFootage) / 1000}k" : "${post.details.squareFootage}"} sq  ",
                                style: _textStyle,
                              )
                            : Container(height: 0, width: 0),
                        post.details.acres != null
                            ? Text(
                                "${int.parse(post.details.acres) > 999 ? "${int.parse(post.details.acres) / 1000}k" : "${post.details.acres}"} acres  ",
                                style: _textStyle,
                              )
                            : Container(height: 0, width: 0),
                        post.details.units != null
                            ? Text(
                                "${int.parse(post.details.units) > 999 ? "${int.parse(post.details.units) / 1000}k" : "${post.details.units}"} units  ",
                                style: _textStyle,
                              )
                            : Container(height: 0, width: 0),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCardTag() {
    if (post.details.turnkeyPrice != null) {
      return Container(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Row(
            children: <Widget>[
              Text(
                "${int.parse(post.details.turnkeyPrice) > 999 ? "${int.parse(post.details.turnkeyPrice) / 1000}k" : "${post.details.turnkeyPrice}"}/mon",
                style: TextStyle(fontSize: 11),
              ),
              Icon(
                Icons.vpn_key,
                size: 10,
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
