import 'dart:convert';

import 'package:avid/utils/card_create_post.dart';
import 'package:avid/utils/style.dart';
import 'package:flutter/material.dart';

import 'search_location_screen.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  //  GlobalKey for ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();

  // To Save Your Location Here
  String _yourCityText;
  String _yourStateText;
  bool _locationError = false;

  // To Save Your Listing Type
  String _listingTypeText;
  bool _listingTypeError = false;

  // To Save Your Property Type
  String _propertyTypeText;
  bool _propertyTypeError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      appBar: AppBar(
        title: Text("Create Post"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _locationPikerWidget(),
          SizedBox(height: 10),
          _listingTypeWidget(),
          SizedBox(height: 10),
          _propertyTypeWidget()
        ],
      ),
    );
  }

  Widget _locationPikerWidget() {
    return CardCreatePost(
      error: _locationError,
      errorMessage: 'Please Choose Location',
      title: "Location:",
      onClick: () async {
        final selected = await showSearch(
            context: context, delegate: SearchLocationScreen());
        setState(() {
          if (selected.isNotEmpty) {
            _yourCityText = jsonDecode(selected)['Title'];
            _yourStateText = jsonDecode(selected)['SubTitle'];
          }
        });
      },
      content: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10),
            decoration: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 5),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                  ),
                  //cityChoose
                  Row(
                    children: <Widget>[
                      Text(
                        _yourCityText == null
                            ? "Select location"
                            : "$_yourCityText",
                        style: Style.styleTextCreatePost,
                      ),
                      Text(
                        _yourStateText == null ? "" : " ,$_yourStateText",
                        style: Style.styleTextSubTitleCreatePost,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listingTypeWidget() {
    return CardCreatePost(
      title: "Listing Type:",
      errorMessage: 'Please Choose Listing Type',
      error: _listingTypeError,
      onClick: () {
        _listingTypeModalBottomSheet(context);
      },
      content: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10),
            decoration: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 5),
                    child: Icon(
                      Icons.assignment_ind,
                      color: Colors.grey,
                    ),
                  ),
                  //cityChoose
                  Text(
                    _listingTypeText == null
                        ? "Select Listing Type"
                        : "$_listingTypeText",
                    style: Style.styleTextCreatePost,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _propertyTypeWidget() {
    return CardCreatePost(
      title: "Property Type:",
      errorMessage: 'Please Choose Property Type',
      error: _propertyTypeError,
      onClick: () {
        //TODO:Here code to choose Property Type
        _propertyTypeModalBottomSheet(context);
      },
      content: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10),
            decoration: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 5),
                    child: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                  ),
                  //cityChoose
                  Text(
                    _propertyTypeText == null
                        ? "Select Property Type"
                        : "$_propertyTypeText",
                    style: Style.styleTextCreatePost,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------- Bottom Sheet Section --------------------------------------------//
  void _listingTypeModalBottomSheet(context) {
    String seller = 'Seller';
    String buyer = 'Buyer';
    String jointVenture = 'Joint Venture';
    List<String> listOfListing=['Seller','Buyer','Joint Venture'];
    Color chooseColor = Colors.black;
    Color defaultValueColor = Colors.white70;
    TextStyle chooseStyle = TextStyle(color: Colors.white);
    TextStyle defaultValueStyle = TextStyle(color: Colors.black);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Listing Type",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  color: _listingTypeText == seller
                      ? chooseColor
                      : defaultValueColor,
                  child: new ListTile(
                      title: new Text(
                        '$seller',
                        style: _listingTypeText == seller
                            ? chooseStyle
                            : defaultValueStyle,
                      ),
                      onTap: () {
                        setState(() {
                          _listingTypeText = seller;
                          Navigator.pop(context);
                        });
                      }),
                ),
                Container(
                  color: _listingTypeText == buyer
                      ? chooseColor
                      : defaultValueColor,
                  child: new ListTile(
                    title: new Text(
                      '$buyer',
                      style: _listingTypeText == buyer
                          ? chooseStyle
                          : defaultValueStyle,
                    ),
                    onTap: () {
                      setState(() {
                        _listingTypeText = buyer;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                Container(
                  color: _listingTypeText == jointVenture
                      ? chooseColor
                      : defaultValueColor,
                  child: new ListTile(
                    title: new Text(
                      '$jointVenture',
                      style: _listingTypeText == jointVenture
                          ? chooseStyle
                          : defaultValueStyle,
                    ),
                    onTap: () {
                      setState(() {
                        _listingTypeText = jointVenture;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _propertyTypeModalBottomSheet(context) {
    String title='Property Type';
    List<String> listOfProperty = [
      'Single',
      'Multi Family',
      'Commercial',
      'Apart/Condo',
      'Accommodation',
      'Land'
    ];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white70,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  dense: true,
                  title: Text(
                    "$title",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                  children: List<Container>.generate(
                      listOfProperty.length,
                          (index) => Container(
                        color: _propertyTypeText == listOfProperty[index]
                            ? CColors.chooseColorCreatePost
                            : CColors.defaultValueColorCraetePost,
                            child: new ListTile(
                                dense: true,
                                title: new Text(
                                  '${listOfProperty[index]}',
                                  style: _propertyTypeText == listOfProperty[index]
                                      ? Style.chooseStyleCreatePost
                                      : Style.defaultValueStyleCreatePost,
                                ),
                                onTap: () {
                                  setState(() {
                                    _propertyTypeText = listOfProperty[index];
                                    Navigator.pop(context);
                                  });
                                }),
                      ),growable: true),
                )
              ],
            ),
          );
        });
  }

}
