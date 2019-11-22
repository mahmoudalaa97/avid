import 'dart:convert';
import 'package:avid/services/geolocation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
import 'package:avid/services/database.dart';
import 'package:avid/utils/card_view_post.dart';
import 'package:flutter/material.dart';
import '../search_location_screen.dart';

class ViewPostScreen extends StatefulWidget {
  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  BaseDatabase database = Database();

//  BaseGeoLocation geolocator=GeoLocation();
  final keySharePrefrance = 'recentSearch';
  final BaseGeoLocation geoLocation = GeoLocation();

  // To Save Your Location Here
  String _yourCityText;

  double lat = 0;
  double long = 0;

  var value;

  @override
  Widget build(BuildContext context) {
    return _buildPostViewWidget();
  }

  Widget _buildPostViewWidget() {
    return Column(
      children: <Widget>[
        _buildSearchAndSort(),
        Flexible(
            child: _yourCityText == null
                ? _streamDefault()
                : _streamSearch(lat, long))
      ],
    );
  }

  Widget _streamDefault() {
    return StreamBuilder(
      stream: database.getPost(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshott) {
        if (snapshott.hasError) return new Text('Error: ${snapshott.error}');
        if (snapshott.hasData) {
          if (snapshott.data.documents.length == 0) {
            return Center(
              child: Text("Data not found in Search!"),
            );
          }
          return ListView.builder(
            itemCount: snapshott.data.documents.length,
            itemBuilder: (BuildContext context, index) {
              Post post =
              Post.fromDocumentJson(snapshott.data.documents[index]);
              return CardViewPost(
                post: post,
                index: index,
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
//                          print(selected);
                          if (selected.isNotEmpty) {
                            setState(() {
                              _yourCityText = jsonDecode(selected)['Title'];
                            });
                            var geolocation = await geoLocation
                                .getLocationQuery(
                                "${jsonDecode(selected)['Title']} ${jsonDecode(
                                    selected)['SubTitle']}");

                            setState(() {
                              lat = geolocation.latitude;
                              long = geolocation.longitude;
                            });
                          } else {
                            _yourCityText = null;
                          }
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
                          onTap: () {
                            // From a query
                          },
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

  Widget _streamSearch(double lat, double long) {
    Geoflutterfire geo = Geoflutterfire();
    // Create a geoFirePoint
    GeoFirePoint center = geo.point(latitude: lat, longitude: long);
// get the collection reference or query
    var collectionReference = Firestore.instance.collection('Post');
    double radius = 20;
    String field = 'Point';
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field, strictMode: true);

    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshott) {
        if (snapshott.hasError) return new Text('Error: ${snapshott.error}');
        if (snapshott.hasData) {
          if (snapshott.data.length == 0) {
            return Center(
              child: Text("Data not found in Search!"),
          );
          }
          return ListView.builder(
            itemCount: snapshott.data.length,
            itemBuilder: (BuildContext context, index) {
              Post post =
              Post.fromDocumentJson(snapshott.data[index]);
              return CardViewPost(
                post: post,
                index: index,
              );
            },
          );
        } else {
        return Center(
          child: CircularProgressIndicator(),
        );
        }
      },
    );
  }
}
