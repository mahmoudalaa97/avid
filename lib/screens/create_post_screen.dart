import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
import 'package:avid/services/auth.dart';
import 'package:avid/services/database.dart';
import 'package:avid/services/geolocation.dart';
import 'package:avid/utils/card_create_post.dart';
import 'package:avid/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image_picker/image_picker.dart';

import 'search_location_screen.dart';

class CreatePostScreen extends StatefulWidget {
  final BaseDatabase database;

  CreatePostScreen({this.database});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  //------------------------------------------------  Parameters Section -------------------------------------//
  //
  final BaseAuth auth = Auth();
  final BaseGeoLocation geoLocation = GeoLocation();
  Geoflutterfire geo = Geoflutterfire();

  //**************************************** Form 1 Parameters **************************************//
  //  GlobalKey for ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  // Check  is valid or not
  bool _autoValidate = false;

  // page Control to control which page is
  PageController _pageController;

  // To Save Your Location Here
  String _yourCityText;
  String _yourStateText;
  bool _locationError = false;

  // To Save Your Listing Type
  List<String> listOfJoinVentureType = [
    'Investment Needed',
    'Help Me Sell',
    'Bring Me A Deal',
    'Back'
  ];
  List<String> listOfPropertyType = [
    'Single',
    'Multi Family',
    'Commercial',
    'Apart/Condo',
    'Accommodation',
    'Land'
  ];
  List<String> listOfBringMeADeal = ['Yes I\'am', 'No I\'am Not', 'Back'];
  List<String> listOfListing = ['Seller', 'Buyer', 'Joint Venture'];
  List<String> listOfTurnkey = [
    'Yes It Is',
    'No It Isn\'t',
  ];
  String _listingTypeText;
  bool _listingTypeError = false;
  String _joinVentureTypeText;
  bool _joinVentureTypeError = false;
  String _bringMeADealTypeText;
  bool _bringMeADealTypeError = false;

  // To Save Your Property Type
  String _propertyTypeText;
  bool _propertyTypeError = false;

  //**************************************** Form 2 Parameters **************************************//

  // To Save Your TurnKey Type
  String _turnkeyListingText;
  bool _turnkeyListingError = false;

  // To Save Your Counter of bedRoomNumber
  int _bedRoomNumber = 1;

  // To Save Your Counter of bathRoomNumber
  int _bathRoomNumber = 1;

  // To Save Your Price
  String _price;

  // default visibility
  bool _priceVisibility = false;
  bool _turnkeyPriceVisibility = false;
  bool _unitsVisibility = false;
  bool _acresVisibility = false;
  bool _squareFootageVisibility = false;
  bool _bedRoomAndBathroomVisibility = false;

  // To Save Your Turnkey Price
  String _turnkeyPrice;

  // To Save Your units
  String _units;

  // To Save Your acres
  String _acres;

  // To Save Your Square Footage
  String _squareFootage;

  // To Save Your Description
  String _description;

  // To Save Your ListOf Images
  List<File> _imagesList = List<File>();

  //------------------------------------------------  BuildWidget Section -------------------------------------//
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backButtonHandel,
      child: Scaffold(
          key: _scaffoldStateKey,
          appBar: AppBar(
            title: Text("Create Post"),
          ),
          backgroundColor: Color(0xfff2f4f6),
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              _buildBodyPage1(),
              _buildBodyPage2(),
            ],
          )),
    );
  }

  //------------------------------------------------  Widget Section -------------------------------------//
  //

  //--------------------------
  //        Page 1
  // ------------------------
  _buildBodyPage1() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white70),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: Text(
                "Information",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            _locationPikerWidget(),
            SizedBox(height: 10),
            _listingTypeWidget(),
            SizedBox(height: 10),
            _jointVentureWidget(),
            _bringMeADealWidget(),
            _propertyTypeWidget(),
            SizedBox(height: 10),
            _isTheTurnkeyListingWidget(),
            SizedBox(height: 10),
            _buttonNextWidget(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  //--------------------------
  //        Page 2
  // ------------------------
  _buildBodyPage2() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white70),
        child: Form(
          key: _formStateKey,
          autovalidate: _autoValidate,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: Text(
                  "Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  Visibility(
                      replacement: Container(),
                      visible: _priceVisibility,
                      child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: _priceTextFiled())),
                  Visibility(
                      replacement: Container(),
                      visible: _turnkeyPriceVisibility,
                      child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: _turnkeyPriceTextFiled())),
                  Visibility(
                      replacement: Container(),
                      visible: _unitsVisibility,
                      child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: _unitsTextFiled())),
                  Visibility(
                      replacement: Container(),
                      visible: _acresVisibility,
                      child: SizedBox(width: 150, child: _acresTextFiled())),
                  Visibility(
                      replacement: Container(),
                      visible: _squareFootageVisibility,
                      child: SizedBox(
                          width: 150, child: _squareFootageTextFiled())),
                ],
              ),
              Visibility(
                replacement: Container(),
                visible: _bedRoomAndBathroomVisibility,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 155, child: _bedRoomsWidget()),
                    SizedBox(width: 155, child: _bathRoomsWidget()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _descriptionTextWidget(),
              SizedBox(height: 15),
              _imagesWidget(),
              SizedBox(height: 10),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buttonPreviousWidget(),
                  _buttonDoneWidget(),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------- Page (1) Section --------------------------------------------//
  Widget _locationPikerWidget() {
    return CardCreatePost(
      error: _locationError,
      errorMessage: 'Please Choose Location',
      title: "Location:",
      onClick: () async {
        final selected = await showSearch(
            context: context, delegate: SearchLocationScreen());
        print(selected);
        setState(() {
          if (selected.isNotEmpty) {
            _yourCityText = jsonDecode(selected)['Title'];
            _yourStateText = jsonDecode(selected)['SubTitle'];
            if (_yourCityText != null) {
              _locationError = false;
            }
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
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5,
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
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Icon(
                      Icons.assignment_ind,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5,
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
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5,
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

  Widget _isTheTurnkeyListingWidget() {
    return CardCreatePost(
      title: "Is This A Turnkey Listing?",
      errorMessage: 'Please Choose Trurnkey',
      error: _turnkeyListingError,
      onClick: () {
        _turnkeyListingModalBottomSheet(context);
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
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Icon(
                      Icons.vpn_key,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  //cityChoose
                  Text(
                    _turnkeyListingText == null
                        ? "Choose Turnkey"
                        : "$_turnkeyListingText",
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

  Widget _jointVentureWidget() {
    return Visibility(
      visible: _listingTypeText == listOfListing[2] ? true : false,
      child: CardCreatePost(
        title: "Join Venture Type",
        errorMessage: 'Please Choose Join Venture Type',
        error: _joinVentureTypeError,
        onClick: () {
          _jointVentureTypeModalBottomSheet(context);
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
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    //cityChoose
                    Text(
                      _joinVentureTypeText == null
                          ? "Choose Joint Venture"
                          : "$_joinVentureTypeText",
                      style: Style.styleTextCreatePost,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bringMeADealWidget() {
    return Visibility(
      visible: _joinVentureTypeText == listOfJoinVentureType[2] ? true : false,
      replacement: Container(),
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: CardCreatePost(
          title: "Bring Me A Deal",
          errorMessage: 'Please Choose Bring Me A Deal',
          error: _bringMeADealTypeError,
          onClick: () {
            _bringMeADealTypeModalBottomSheet(context);
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
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      //cityChoose
                      Text(
                        _bringMeADealTypeText == null
                            ? "Choose Bring Me A Deal"
                            : "$_bringMeADealTypeText",
                        style: Style.styleTextCreatePost,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------- Page (2) Section --------------------------------------------//
  TextStyle titleStylePage2 = TextStyle(
      color: Color(0xff24253D), fontWeight: FontWeight.bold, fontSize: 15);
  TextStyle hintStylePage2 = TextStyle(fontSize: 13);

  Widget _priceTextFiled() {
    return CardCreatePost(
      title: 'Price:',
      textStyle: titleStylePage2,
      content: TextFormField(
        initialValue: _price,
        onChanged: (price) {
          _price = price;
        },
        onSaved: (price) {
          _price = price;
        },
        validator: (price) {
          if (price.length == 0)
            return 'Must Not Empty!';
          else
            return null;
        },
        decoration:
        InputDecoration(hintText: 'Price', hintStyle: hintStylePage2),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _turnkeyPriceTextFiled() {
    return CardCreatePost(
      title: 'Turnkey Price:',
      textStyle: titleStylePage2,
      content: TextFormField(
        initialValue: _turnkeyPrice,
        onChanged: (turnkeyPrice) {
          _turnkeyPrice = turnkeyPrice;
        },
        onSaved: (turnkeyPrice) {
          _turnkeyPrice = turnkeyPrice;
        },
        validator: (turnkeyPrice) {
          if (turnkeyPrice.length == 0)
            return 'Must Not Empty!';
          else
            return null;
        },
        decoration: InputDecoration(
            hintText: 'Turnkey Price...', hintStyle: hintStylePage2),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _unitsTextFiled() {
    return CardCreatePost(
      title: 'Units:',
      textStyle: titleStylePage2,
      content: TextFormField(
        initialValue: _units,
        onChanged: (units) {
          _units = units;
        },
        onSaved: (units) {
          _units = units;
        },
        validator: (units) {
          if (units.length == 0)
            return 'Must Not Empty!';
          else
            return null;
        },
        decoration:
        InputDecoration(hintText: 'Units', hintStyle: hintStylePage2),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _acresTextFiled() {
    return CardCreatePost(
      title: 'Acres:',
      textStyle: titleStylePage2,
      content: TextFormField(
        initialValue: _acres,
        onChanged: (acres) {
          _acres = acres;
        },
        onSaved: (acres) {
          _acres = acres;
        },
        validator: (acres) {
          if (acres.length == 0)
            return 'Must Not Empty!';
          else
            return null;
        },
        decoration:
        InputDecoration(hintText: 'Acres', hintStyle: hintStylePage2),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _squareFootageTextFiled() {
    return CardCreatePost(
      title: 'Square Footage:',
      textStyle: titleStylePage2,
      content: TextFormField(
        initialValue: _squareFootage,
        onChanged: (squareFootage) {
          _squareFootage = squareFootage;
        },
        onSaved: (squareFootage) {
          _squareFootage = squareFootage;
        },
        validator: (squareFootage) {
          if (squareFootage.length == 0)
            return 'Must Not Empty!';
          else
            return null;
        },
        decoration: InputDecoration(
            hintText: 'Square Footage', hintStyle: hintStylePage2),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _bedRoomsWidget() {
    return CardCreatePost(
      title: 'Bed Room:',
      textStyle: titleStylePage2,
      content: _counter(
          numberName: _bedRoomNumber,
          onValueChang: (number) {
            _bedRoomNumber = number;
          }),
    );
  }

  Widget _bathRoomsWidget() {
    return CardCreatePost(
      title: 'Bath Rooms: ',
      textStyle: titleStylePage2,
      content: _counter(
          numberName: _bathRoomNumber,
          onValueChang: (number) {
            _bathRoomNumber = number;
          }),
    );
  }

  Widget _descriptionTextWidget() {
    return CardCreatePost(
        title: 'Description:',
        textStyle: titleStylePage2,
        content: TextFormField(
          initialValue: _description,
          onChanged: (description) {
            _description = description;
          },
          onSaved: (description) {
            _description = description;
          },
          validator: (description) {
            if (description.length == 0)
              return 'Must Not Empty!';
            else
              return null;
          },
          buildCounter: (BuildContext context,
              {int currentLength, int maxLength, bool isFocused}) {
            return Text("$currentLength/$maxLength");
          },
          maxLength: 300,
          decoration: InputDecoration(
            hintText: 'Describe Your Listing...',
            hintStyle: hintStylePage2,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ));
  }

  Widget _imagesWidget() {
    return CardCreatePost(
      title: "Pictures:",
      textStyle: titleStylePage2,
      content: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 5),
              child: _imagesList.isNotEmpty
                  ? GridView.builder(
                  itemCount: _imagesList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:
                  new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                        height: 85,
                        width: 85,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)),
                        child: InkWell(
                            onTap: () {
                              _alertDialogChooseImageAndDelete(
                                  delete: true, index: index, edit: true);
                            },
                            child: Image.file(
                              _imagesList[index],
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.medium,
                            )));
                  })
                  : Container(
                alignment: Alignment(0, 0),
                height: 100,
                child: Text(
                  "Tap button to add image",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              )),
          Container(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                _alertDialogChooseImageAndDelete(edit: false);
              },
              child: CircleAvatar(
                maxRadius: 25,
                child: Center(child: Icon(Icons.add_a_photo)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _alertDialogChooseImageAndDelete(
      {bool delete = false, int index, bool edit}) {
    var textStyle = TextStyle(fontSize: 15);
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: AlertDialog(
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Select source",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 5),
                    FlatButton(
                        onPressed: () {
                          _uploadImage(
                              imageSource: ImageSource.camera,
                              edit: edit,
                              index: index);
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Take Photo",
                            style: textStyle,
                            textAlign: TextAlign.left,
                          ),
                        )),
                    SizedBox(height: 5),
                    FlatButton(
                        onPressed: () {
                          _uploadImage(
                              imageSource: ImageSource.gallery,
                              edit: edit,
                              index: index);
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Choose from Gallery",
                            style: textStyle,
                          ),
                        )),
                    SizedBox(height: 5),
                    delete
                        ? Container(
                      alignment: Alignment.centerLeft,
                      child: FlatButton(
                          onPressed: () {
                            _deleteImage(index: index);
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Delete",
                              style: textStyle,
                            ),
                          )),
                    )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _counter({int numberName, ValueChanged<int> onValueChang}) {
    int number = numberName;
    double height = 30;
    double width = 40;

    Color active = Color(0xff12354c);
    Color disable = Color(0xff06629c);
    return Container(
      margin: EdgeInsets.only(top: 5, left: 2),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                  flex: 3,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        color: number >= 2 ? active : disable,
                        border: Border.all(color: Colors.black54, width: 0.4),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5))),
                    child: InkWell(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 18,
                      ),
                      onTap: () {
                        setState(() {
                          if (number > 1) {
                            number--;
                            onValueChang(number);
                          } else {
                            return null;
                          }
                        });
                      },
                    ),
                  )),
              Flexible(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    height: height,
                    width: 45,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(color: Colors.black54, width: 0.4)),
                    child: Text(
                      "$number",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                  )),
              Flexible(
                  flex: 3,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        color: active,
                        border: Border.all(color: Colors.black54, width: 0.4),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: InkWell(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                      onTap: () {
                        setState(() {
                          number++;
                          onValueChang(number);
                        });
                      },
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

//--------------------------------------- Bottom Sheet Section --------------------------------------------//
  void _listingTypeModalBottomSheet(context) {
    String title = "Listing Type";
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white70,
            child: new Wrap(
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
                      listOfListing.length,
                          (index) =>
                          Container(
                            color: _listingTypeText == listOfListing[index]
                                ? CColors.chooseColorCreatePost
                                : CColors.defaultValueColorCraetePost,
                            child: new ListTile(
                                dense: true,
                                title: new Text(
                                  '${listOfListing[index]}',
                                  style:
                                  _listingTypeText == listOfListing[index]
                                      ? Style.chooseStyleCreatePost
                                      : Style.defaultValueStyleCreatePost,
                                ),
                                onTap: () {
                                  setState(() {
                                    if (index == 2) {
                                      Navigator.pop(context);
                                      _jointVentureTypeModalBottomSheet(
                                          context);
                                      _listingTypeText = listOfListing[index];
                                    } else {
                                      _listingTypeText = listOfListing[index];
                                      _bringMeADealTypeText = null;
                                      _joinVentureTypeText = null;
                                      _listingTypeError = false;
                                      Navigator.pop(context);
                                    }
                                  });
                                }),
                          )),
                )
              ],
            ),
          );
        });
  }

  void _propertyTypeModalBottomSheet(context) {
    String title = 'Property Type';
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
                    listOfPropertyType.length,
                        (index) =>
                        Container(
                          color: _propertyTypeText == listOfPropertyType[index]
                              ? CColors.chooseColorCreatePost
                              : CColors.defaultValueColorCraetePost,
                          child: new ListTile(
                              dense: true,
                              title: new Text(
                                '${listOfPropertyType[index]}',
                                style:
                                _propertyTypeText == listOfPropertyType[index]
                                    ? Style.chooseStyleCreatePost
                                    : Style.defaultValueStyleCreatePost,
                              ),
                              onTap: () {
                                setState(() {
                                  _propertyTypeText = listOfPropertyType[index];
                                  _propertyTypeError = false;
                                  Navigator.pop(context);
                                });
                              }),
                        ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _turnkeyListingModalBottomSheet(context) {
    String title = 'Is This A TurnKey Listing?';

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
                    listOfTurnkey.length,
                        (index) =>
                        Container(
                          color: _turnkeyListingText == listOfTurnkey[index]
                              ? CColors.chooseColorCreatePost
                              : CColors.defaultValueColorCraetePost,
                          child: new ListTile(
                              dense: true,
                              title: new Text(
                                '${listOfTurnkey[index]}',
                                style: _turnkeyListingText ==
                                    listOfTurnkey[index]
                                    ? Style.chooseStyleCreatePost
                                    : Style.defaultValueStyleCreatePost,
                              ),
                              onTap: () {
                                setState(() {
                                  _turnkeyListingText = listOfTurnkey[index];
                                  _turnkeyListingError = false;
                                  Navigator.pop(context);
                                });
                              }),
                        ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _jointVentureTypeModalBottomSheet(context) {
    String title = "Join Venture Type";
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white70,
            child: new Wrap(
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
                      listOfJoinVentureType.length,
                          (index) =>
                          Container(
                            color: _joinVentureTypeText ==
                                listOfJoinVentureType[index]
                                ? CColors.chooseColorCreatePost
                                : CColors.defaultValueColorCraetePost,
                            child: new ListTile(
                                dense: true,
                                title: new Text(
                                  '${listOfJoinVentureType[index]}',
                                  style: _joinVentureTypeText ==
                                      listOfJoinVentureType[index]
                                      ? Style.chooseStyleCreatePost
                                      : Style.defaultValueStyleCreatePost,
                                ),
                                onTap: () {
                                  setState(() {
                                    switch (index) {
                                      case 3:
                                        Navigator.pop(context);
                                        _listingTypeModalBottomSheet(context);
                                        break;
                                      case 2:
                                        Navigator.pop(context);
                                        _bringMeADealTypeModalBottomSheet(
                                            context);
                                        _joinVentureTypeText =
                                        listOfJoinVentureType[index];
                                        _joinVentureTypeError = false;
                                        break;
                                      default:
                                        _joinVentureTypeText =
                                        listOfJoinVentureType[index];
                                        _joinVentureTypeError = false;
                                        Navigator.pop(context);
                                        break;
                                    }
                                  });
                                }),
                          )),
                )
              ],
            ),
          );
        });
  }

  void _bringMeADealTypeModalBottomSheet(context) {
    String title = "Can You Invest";

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white70,
            child: new Wrap(
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
                      listOfBringMeADeal.length,
                          (index) =>
                          Container(
                            color: _bringMeADealTypeText ==
                                listOfBringMeADeal[index]
                                ? CColors.chooseColorCreatePost
                                : CColors.defaultValueColorCraetePost,
                            child: new ListTile(
                                dense: true,
                                title: new Text(
                                  '${listOfBringMeADeal[index]}',
                                  style: _bringMeADealTypeText ==
                                      listOfBringMeADeal[index]
                                      ? Style.chooseStyleCreatePost
                                      : Style.defaultValueStyleCreatePost,
                                ),
                                onTap: () {
                                  setState(() {
                                    if (index == 2) {
                                      Navigator.pop(context);
                                      _jointVentureTypeModalBottomSheet(
                                          context);
                                    } else {
                                      _bringMeADealTypeText =
                                      listOfBringMeADeal[index];
                                      _bringMeADealTypeError = false;
                                      Navigator.pop(context);
                                    }
                                  });
                                }),
                          )),
                )
              ],
            ),
          );
        });
  }

  //--------------------------------------- Method Section ---------------------------------------------//
  //---------------------------------------------------------------------------------------------------//

  _buttonNextWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: RaisedButton(
        onPressed: () {
          _validateForm1();
        },
        child: Text(
          "Next",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
      ),
    );
  }

  _buttonPreviousWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      child: FlatButton(
        onPressed: () {
          _pageController.previousPage(
              duration: Duration(milliseconds: 500), curve: SawTooth(1));
        },
        child: Text(
          "Previous",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  _buttonDoneWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: RaisedButton(
        onPressed: () {
          _validateForm2();
        },
        child: Text(
          "Done",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
      ),
    );
  }

  //**************************************** Form 1 Method **************************************//

  _validateForm1() {
    //Error method to check if selected or empty
    if (_errorValidateForm1()) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 800), curve: Curves.easeInToLinear);
    }

    //Method To show Item In Form2
    _showItemInForm2();
  }

  _showItemInForm2() {
    setState(() {
      //--------------------  Condition To Show Details Section For Property Type ---------------------------
      if (_propertyTypeText == listOfPropertyType[0]) {
        _bedRoomAndBathroomVisibility = true;
        _squareFootageVisibility = true;
        _acresVisibility = true;
        _units = null;
        _unitsVisibility = false;
      } else if (_propertyTypeText == listOfPropertyType[1] ||
          _propertyTypeText == listOfPropertyType[2] ||
          _propertyTypeText == listOfPropertyType[3] ||
          _propertyTypeText == listOfPropertyType[4]) {
        _bedRoomAndBathroomVisibility = false;
        _unitsVisibility = true;
        _squareFootageVisibility = true;
        _acresVisibility = true;
        //Reset Data Default
        _bedRoomNumber = 0;
        _bathRoomNumber = 0;
      } else if (_propertyTypeText == listOfPropertyType[5]) {
        _bedRoomAndBathroomVisibility = false;
        _unitsVisibility = false;
        _squareFootageVisibility = false;
        //Reset Data Default
        _units = null;
        _squareFootage = null;
        _bedRoomNumber = 0;
        _bathRoomNumber = 0;
        _acresVisibility = true;
      }
      //------------------------------------------------------------------------

      if (_listingTypeText == listOfListing[0] ||
          _listingTypeText == listOfListing[1]) {
        _priceVisibility = true;
        _bringMeADealTypeText = null;
        _joinVentureTypeText = null;
      } else if (_listingTypeText == listOfListing[2] &&
          _joinVentureTypeText == listOfJoinVentureType[0]) {
        _priceVisibility = true;
      } else if (_listingTypeText == listOfListing[2] &&
          _joinVentureTypeText == listOfJoinVentureType[2] &&
          _bringMeADealTypeText == listOfBringMeADeal[0]) {
        _priceVisibility = true;
      } else {
        _priceVisibility = false;
        _price = null;
      }
      //------------------------------------------------------------------------

      if (_turnkeyListingText == listOfTurnkey[0]) {
        _turnkeyPriceVisibility = true;
      } else {
        _turnkeyPriceVisibility = false;
        _turnkeyPrice = null;
      }
    });
  }

  _errorValidateForm1() {
    //Error Validate
    setState(() {
      if (_yourCityText == null) {
        _locationError = true;
      }
      if (_listingTypeText == null) {
        _listingTypeError = true;
      }
      if (_propertyTypeText == null) {
        _propertyTypeError = true;
      }
      if (_turnkeyListingText == null) {
        _turnkeyListingError = true;
      }

      if (_listingTypeText == listOfListing[2] &&
          _joinVentureTypeText == null) {
        _joinVentureTypeError = true;
      } else {
        _joinVentureTypeError = false;
      }
      if (_listingTypeText == listOfListing[2] &&
          _joinVentureTypeText == listOfJoinVentureType[2] &&
          _bringMeADealTypeText == null) {
        _bringMeADealTypeError = true;
      } else {
        _bringMeADealTypeError = false;
      }

//      if (_joinVentureTypeText == listOfJoinVentureType[2] &&
//          _bringMeADealTypeText == null) {
//        _listingTypeError = true;
//      } else {
//        _listingTypeError = false;
//      }
    });
    if (!_listingTypeError &&
        !_locationError &&
        !_propertyTypeError &&
        !_turnkeyListingError &&
        !_joinVentureTypeError &&
        !_bringMeADealTypeError) {
      return true;
    } else {
      _scaffoldStateKey.currentState.showSnackBar(SnackBar(
        content: Text("Complete Form First"),
        duration: Duration(milliseconds: 600),
      ));
      return false;
    }
    //End Error Validate
  }

  //**************************************** Form 2 Method **************************************//

  _uploadImage({ImageSource imageSource, bool edit = false, int index}) async {
    if (_imagesList.length <= 6) {
      var image = await ImagePicker.pickImage(
          source: imageSource, maxHeight: 500, maxWidth: 500);
      if (image != null) {
        setState(() {
          if (edit) {
            print("True==$index");
            _imagesList[index] = image;

            return _imagesList;
          } else {
            _imagesList.add(image);
            return _imagesList;
          }
        });
      }
    } else {
      _scaffoldStateKey.currentState
          .showSnackBar(SnackBar(content: (Text("Maximum limit Pictures"))));
    }
  }

  _deleteImage({index}) {
    setState(() {
      _imagesList.removeAt(index);
    });
  }

  _validateForm2() async {
    if (_formStateKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formStateKey.currentState.save();
      if (_imagesList.isNotEmpty) {
        _showAlertLoading();
        try {
          String userId = await auth.currentUser();
          var pictureList = await widget.database
              .uploadPostPicture(picturesList: _imagesList);
          User user = await widget.database.getCurrentUser();
          var coordinates = await geoLocation
              .getLocationQuery("$_yourCityText, $_yourStateText");
          GeoFirePoint point = geo.point(
              latitude: coordinates.latitude, longitude: coordinates.longitude);
          try {
            widget.database.createPost(
                post: Post(
                    dateTime: Timestamp.now(),
                    userId: userId,
                    point: point.data,
                    nameUser: user.username,
                    imageUser: user.profilePicture,
                    location:
                    Location(city: _yourCityText, state: _yourStateText),
                    listingType: _listingTypeText,
                    joinVentureType: _joinVentureTypeText,
                    bringMeADeal: _bringMeADealTypeText,
                    turnkeyListing: _turnkeyListingText,
                    propertyType: _propertyTypeText,
                    details: Details(
                        pictures: pictureList,
                        acres: _acres,
                        units: _units,
                        squareFootage: _squareFootage,
                        price: _price,
                        turnkeyPrice: _turnkeyPrice,
                        bathRoom: _bathRoomNumber == 0
                            ? null
                            : _bathRoomNumber.toString(),
                        bedRoom: _bedRoomNumber == 0
                            ? null
                            : _bedRoomNumber.toString(),
                        description: _description)));

            _postSuccessfully();
          } catch (e) {}
        } catch (e) {
          print("Error==$e");
        }
      } else {
        _scaffoldStateKey.currentState
            .showSnackBar(SnackBar(content: Text("Must select 1 Picture")));
      }
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _showAlertLoading({bool show}) {
    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: Text("Create Post"),
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        },
        barrierDismissible: false);
  }

//successfully
  _postSuccessfully() {
    _scaffoldStateKey.currentState.showSnackBar(SnackBar(
      content: Text("Post Success"),
      backgroundColor: Colors.green,
      duration: Duration(milliseconds: 800),
    ));

    Navigator.pop(context);
    Timer(Duration(milliseconds: 800), () => Navigator.pop(context));
  }

  Future<bool> _backButtonHandel() async {
    if (_pageController.page == 0) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (cb) =>
              AlertDialog(
                title: Text("AVid"),
                content: Text(
                    "All changes will be lost.Do you want to go back?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () => Navigator.of(cb).pop(false),
                  ),
                  FlatButton(
                    child: Text("YES"),
                    onPressed: () => Navigator.of(cb).pop(true),
                  )
                ],
              )) ??
          false;
    } else {
      _pageController.previousPage(
          duration: Duration(milliseconds: 500), curve: SawTooth(1));
      return false;
    }
  }
}
