import 'package:avid/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const kGoogleApiKey = "AIzaSyCuPOKCPCITepwsA0-F54UN9ZLfd9JQKV8";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class SearchLocation extends SearchDelegate<String> {
  String city = "";
  String state = "";
  List<Prediction> predictionLocation;
  var _width;
  var _height;
  final keySharePrefrance = 'recentSearch';
  Map lastRecentSearch;

  Future<List<Prediction>> getPlace(String city) async {
    final predicationResponse = await _places.autocomplete(city,
        language: "en",
        types: ["(regions)"],
        components: [Component(Component.country, "us")]);
    List<Prediction> predictionValues = predicationResponse.predictions;
    return predictionValues;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return Container(
      color: Colors.red,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: getPlace(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          getPlace(city);
          predictionLocation = snapshot.data;
          switch (query.isEmpty) {
            case false:
              return _buildListSearchWithRecentlySearched();
              break;
          }
        }
        return _buildListRecentlySearched();
      },
    );
  }

  Widget _buildListSearchWithRecentlySearched() {
    return ListView(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[_buildListSearch(), _buildListRecentlySearched()],
    );
  }

  Widget _buildListSearch() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: predictionLocation.length,
        itemBuilder: (context, index) {
//          print(index.toString());
          return Column(
            children: <Widget>[
              ListTile(
                onTap: () async {
                  city =
                      predictionLocation[index].structuredFormatting.mainText;
//                  print(city);
                  Navigator.pop(context, jsonEncode({
                    "Title":
                        predictionLocation[index].structuredFormatting.mainText,
                    "SubTitle": predictionLocation[index]
                        .structuredFormatting
                        .secondaryText
                  }));
                  //------------------------- Test ----------------
                  Map value = {
                    "Title":
                        predictionLocation[index].structuredFormatting.mainText,
                    "SubTitle": predictionLocation[index]
                        .structuredFormatting
                        .secondaryText,
                  };
//                  lastRecentSearch = jsonDecode(await _readTitle());
//                  print(lastRecentSearch.containsValue(value));
//                  if(!lastRecentSearch.containsValue(value)) {
                  _saveTitle(jsonEncode(value));
//                  }
                },
                title: Text(
                  "${predictionLocation[index].structuredFormatting.mainText}",
                  style: Style.styleTitleSearchLocation,
                ),
                subtitle: Text(
                  "${predictionLocation[index].structuredFormatting.secondaryText}",
                  style: Style.styleSubTitleSearchLocation,
                ),
              ),
              Divider(
                color: Colors.grey[800],
                height: 0,
                indent: 10,
                endIndent: 10,
              ),
            ],
          );
        });
  }

  Widget _buildListRecentlySearched() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            color: Colors.grey[200],
            child: Text(
              "Recently Searched",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          FutureBuilder(
            future: _readTitle(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context, snapshot.data);
                              },
                              title: Text(
                                "${jsonDecode(snapshot.data)['Title']}",
                                style: Style.styleTitleSearchLocation,
                              ),
                              subtitle: Text(
                                "${jsonDecode(snapshot.data)['SubTitle']}",
                                style: Style.styleSubTitleSearchLocation,
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[800],
                            height: 0,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ],
                      );
                    });
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Future<String> _readTitle() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(keySharePrefrance) ?? null;
//    print('read: $value');
    return value;
  }

  _saveTitle(String value) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(keySharePrefrance, value);
//      print('saved $value');
    });
  }
}
