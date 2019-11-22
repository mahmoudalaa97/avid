import 'package:avid/model/Post.dart';
import 'package:avid/model/User.dart';
import 'package:flutter/material.dart';

class CardViewPost extends StatefulWidget {
  final Post post;
  final String timesPost;
  final bool favorite;
  final int index;

  CardViewPost(
      {this.post, this.timesPost, this.favorite = true, this.index = 0,});

  @override
  _CardViewPostState createState() => _CardViewPostState();
}

class _CardViewPostState extends State<CardViewPost> {
  @override
  Widget build(BuildContext context) {
    int differenceMinutes = DateTime
        .now()
        .difference(widget.post.dateTime.toDate())
        .inMinutes;
    int differenceHours =
        DateTime
            .now()
            .difference(widget.post.dateTime.toDate())
            .inHours;
    int differenceDays =
        DateTime
            .now()
            .difference(widget.post.dateTime.toDate())
            .inDays;
    return Container(
      margin: EdgeInsets.only(bottom: 5, top: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        margin: EdgeInsets.all(2),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 50,
                margin: EdgeInsets.all(7),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  widget.post.imageUser))),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(7),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.post.nameUser,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                )),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    widget.post.dateTime != null
                                        ? differenceMinutes < 60
                                        ? "$differenceMinutes Minutes"
                                        : differenceMinutes >= 60 &&
                                        differenceMinutes < 1440
                                        ? "$differenceHours Hours"
                                        : differenceMinutes >= 1440 &&
                                        differenceMinutes <=
                                            40320
                                        ? "$differenceDays Days"
                                        : "${differenceDays ~/ 28} Months"
                                        : "",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11),
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
                                    "${widget.post.location.city}, ${widget.post
                                        .location.state}",
                                    style: TextStyle(fontSize: 11),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    widget.favorite
                        ? Icon(
                      Icons.favorite,
                      size: 22,
                      color: Colors.red,
                    )
                        : Icon(
                      Icons.favorite_border,
                      size: 22,
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _onTap(widget.index);
                },
                child: Container(
                  height: 250,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Stack(
                    children: <Widget>[
                      Hero(
                        tag: "${widget.index}",
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "${widget.post.details.pictures[0]}"),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      Positioned(
                          top: 10,
                          left: 10,
                          child: Wrap(
                            children: <Widget>[_buildCardTag()],
                          )),
                      Positioned(left: 10, bottom: 5, child: _buildFooterTag()),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Text(
                          "1 of ${widget.post.details.pictures.length}",
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w600),),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildFooterTag() {
    TextStyle _textStyle = TextStyle(
        color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500);
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        children: <Widget>[
          widget.post.details.price != null
              ? Container(
              alignment: Alignment.centerLeft,
              child: int.parse(widget.post.details.price) >= 999
                  ? Text("\$ ${widget.post.details.price}k asking price",
                  style: _textStyle)
                  : Text(
                "\$ ${widget.post.details.price} asking price",
                style: _textStyle,
              ))
              : Container(
            height: 0,
            width: 0,
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 5,
                children: <Widget>[
                  widget.post.propertyType != null
                      ? Text(
                    "${widget.post.propertyType}",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.turnkeyListing != null
                      ? Text(
                    "Turnkey Listing",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.listingType != null
                      ? Text(
                    "${widget.post.listingType}",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.joinVentureType != null
                      ? Text(
                    "${widget.post.joinVentureType}",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.bringMeADeal != null
                      ? Text(
                    "Bring Me A Deal",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                ],
              )),
          Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 2,
                runSpacing: 5,
                children: <Widget>[
                  widget.post.details.bedRoom != null
                      ? Text(
                    "${widget.post.details.bedRoom} bd",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.details.bathRoom != null
                      ? Text(
                    "${widget.post.details.bathRoom} ba",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.details.squareFootage != null
                      ? Text(
                    "${int.parse(widget.post.details.squareFootage) > 999
                        ? "${widget.post.details.squareFootage}k"
                        : "${widget.post.details.squareFootage}"} sq",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.details.acres != null
                      ? Text(
                    "${int.parse(widget.post.details.acres) > 999 ? "${widget
                        .post.details.acres}k" : "${widget.post.details
                        .acres}"} acres",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.details.units != null
                      ? Text(
                    "${int.parse(widget.post.details.units) > 999 ? "${widget
                        .post.details.units}k" : "${widget.post.details
                        .units}"} units",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                ],
              ))
        ],
      ),
    );
  }

  _buildCardTag() {
    if (widget.post.details.turnkeyPrice != null) {
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Row(
            children: <Widget>[
              Text(
                  "${int.parse(widget.post.details.turnkeyPrice) > 999
                      ? "${int.parse(widget.post.details.turnkeyPrice) / 1000}k"
                      : "${widget.post.details.turnkeyPrice}"}/mon"),
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

  void _onTap(index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            DetailsPost(favorite: false,
              post: widget.post,
              index: widget.index,)));
  }
}

class DetailsPost extends StatefulWidget {
  final Post post;
  final bool favorite;
  final int index;

  const DetailsPost({Key key, this.favorite, this.post, this.index})
      : super(key: key);

  @override
  _DetailsPostState createState() => _DetailsPostState();
}

class _DetailsPostState extends State<DetailsPost> {
  int indexImage = 1;

  @override
  Widget build(BuildContext context) {
    int differenceMinutes = DateTime
        .now()
        .difference(widget.post.dateTime.toDate())
        .inMinutes;
    int differenceHours =
        DateTime
            .now()
            .difference(widget.post.dateTime.toDate())
            .inHours;
    int differenceDays =
        DateTime
            .now()
            .difference(widget.post.dateTime.toDate())
            .inDays;
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 60,
                    margin: EdgeInsets.all(7),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      widget.post.imageUser),
                                  fit: BoxFit.fill)),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(7),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "${widget.post.nameUser}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        widget.post.dateTime != null
                                            ? differenceMinutes < 60
                                            ? "$differenceMinutes Minutes"
                                            : differenceMinutes >= 60 &&
                                            differenceMinutes < 1440
                                            ? "$differenceHours Hours"
                                            : differenceMinutes >=
                                            1440 &&
                                            differenceMinutes <=
                                                40320
                                            ? "$differenceDays Days"
                                            : "${differenceDays ~/ 28} Months"
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11),
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
                                        "${widget.post.location.city}, ${widget
                                            .post.location.state}",
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        widget.favorite
                            ? Icon(
                          Icons.favorite,
                          size: 22,
                          color: Colors.red,
                        )
                            : Icon(
                          Icons.favorite_border,
                          size: 22,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    height: 300,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: "${widget.index}",
                          child: PageView.builder(
                            itemCount: widget.post.details.pictures.length,
                            onPageChanged: (value) {
                              setState(() {
                                indexImage = value + 1;
                                print(value);
                              });
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(widget
                                            .post.details.pictures[index]),
                                        fit: BoxFit.fill)),
                              );
                            },
                          ),
                        ),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Wrap(
                              children: <Widget>[_buildCardTag()],
                            )),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Text(
                            "$indexImage of ${widget.post.details.pictures
                                .length}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                  _buildFooterTag()
                ],
              ),
            ),
            _buildFooterButton()
          ],
        ));
  }

  _buildFooterButton() {
    TextStyle _textStyle = TextStyle(color: Colors.white, fontSize: 16);
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 50,
            child: RaisedButton(
              splashColor: Colors.white,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              onPressed: () {},
              child: Text(
                "Message",
                style: _textStyle,
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          width: 1,
          color: Colors.white,
        ),
        Expanded(
          child: Container(
            height: 50,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              splashColor: Colors.white,
              color: Colors.black,
              onPressed: () {},
              child: Text(
                "View Profile",
                style: _textStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildFooterTag() {
    TextStyle _textStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12);
    return Container(
      margin: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        children: <Widget>[
          widget.post.details.price != null
              ? Container(
              alignment: Alignment.centerLeft,
              child: int.parse(widget.post.details.price) >= 999
                  ? Text(
                  "\$ ${int.parse(widget.post.details.price) /
                      1000}k asking price",
                  style: _textStyle)
                  : Text(
                "\$ ${widget.post.details.price} asking price",
                style: _textStyle,
              ))
              : Container(height: 0, width: 0),
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, bottom: 5),
              child: Wrap(
                spacing: 10,
                children: <Widget>[
                  widget.post.propertyType != null
                      ? Text(
                    "${widget.post.propertyType}",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.turnkeyListing != null
                      ? Text(
                    "Turnkey Listing",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.listingType != null
                      ? Text(
                    "${widget.post.listingType}",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.joinVentureType != null
                      ? Text(
                    "${widget.post.joinVentureType}",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.bringMeADeal != null
                      ? Text(
                    "Bring Me A Deal",
                    style: _textStyle,
                  )
                      : Container(
                    height: 0,
                    width: 0,
                  ),
                ],
              )),
          Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 0,
                runSpacing: 5,
                children: <Widget>[
                  widget.post.details.bedRoom != null
                      ? Text(
                    "${widget.post.details.bedRoom} bd  ",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.details.bathRoom != null
                      ? Text(
                    "${widget.post.details.bathRoom}ba  ",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.details.squareFootage != null
                      ? Text(
                    "${int.parse(widget.post.details.squareFootage) > 999
                        ? "${int.parse(widget.post.details.squareFootage) /
                        1000}k"
                        : "${widget.post.details.squareFootage}"} sq  ",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.details.acres != null
                      ? Text(
                    "${int.parse(widget.post.details.acres) > 999 ? "${int
                        .parse(widget.post.details.acres) / 1000}k" : "${widget
                        .post.details.acres}"} acres  ",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                  widget.post.details.units != null
                      ? Text(
                    "${int.parse(widget.post.details.units) > 999 ? "${int
                        .parse(widget.post.details.units) / 1000}k" : "${widget
                        .post.details.units}"} units  ",
                    style: _textStyle,
                  )
                      : Container(height: 0, width: 0),
                ],
              )),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Overview:",
                  style: _textStyle,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(widget.post.details.description))
            ],
          )
        ],
      ),
    );
  }

  _buildCardTag() {
    if (widget.post.details.turnkeyPrice != null) {
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Row(
            children: <Widget>[
              Text(
                  "${int.parse(widget.post.details.turnkeyPrice) > 999
                      ? "${int.parse(widget.post.details.turnkeyPrice) / 1000}k"
                      : "${widget.post.details.turnkeyPrice}"}/mon"),
              Icon(
                Icons.vpn_key,
                size: 10,
              )
            ],
          ),
        ),
      );
    } else
      return Container();
  }
}
