import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'User.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  String key;
  String bringMeADeal;
  Details details;
  String joinVentureType;
  String listingType;
  Location location;
  String propertyType;
  String turnkeyListing;
  String userId;
  User user;
  String dateTime;

  Post({
    this.user,
    this.key,
    this.bringMeADeal,
    this.details,
    this.joinVentureType,
    this.listingType,
    this.location,
    this.propertyType,
    this.turnkeyListing,
    this.userId,
    this.dateTime
  });

  factory Post.fromJson(Map<String, dynamic> json) =>
      new Post(
        dateTime: json["DateTime"],
        bringMeADeal: json["BringMeADeal"],
        details: Details.fromJson(json["Details"]),
        joinVentureType: json["JoinVentureType"],
        listingType: json["ListingType"],
        location: Location.fromJson(json["Location"]),
        propertyType: json["PropertyType"],
        turnkeyListing: json["TurnkeyListing"],
        userId: json["UserId"],
      );

  Post.fromSnapshotJson(DataSnapshot snapshot) {
    key = snapshot.key;
    dateTime = snapshot.value["DateTime"];
    bringMeADeal = snapshot.value["BringMeADeal"];
    joinVentureType = snapshot.value["JoinVentureType"];
    listingType = snapshot.value["ListingType"];
    location = Location.fromSnapshotJson(snapshot);
    details = Details.fromSnapshotJson(snapshot);
    propertyType = snapshot.value["PropertyType"];
    turnkeyListing = snapshot.value["TurnkeyListing"];
    userId = snapshot.value["UserId"];
  }

  Map<String, dynamic> toJson() =>
      {
        "DateTime": dateTime,
        "BringMeADeal": bringMeADeal,
        "Details": details.toJson(),
        "JoinVentureType": joinVentureType,
        "ListingType": listingType,
        "Location": location.toJson(),
        "PropertyType": propertyType,
        "TurnkeyListing": turnkeyListing,
        "UserId": userId,
      };
}

class Details {
  String acres;
  String units;
  String bathRoom;
  String bedRoom;
  String price;
  String squareFootage;
  String turnkeyPrice;
  String description;
  List<String> pictures;

  Details({
    this.acres,
    this.units,
    this.bathRoom,
    this.bedRoom,
    this.price,
    this.squareFootage,
    this.turnkeyPrice,
    this.description,
    this.pictures,
  });

  factory Details.fromJson(Map<String, dynamic> json) =>
      new Details(
        acres: json["Acres"],
        units: json["Units"],
        bathRoom: json["BathRoom"],
        bedRoom: json["BedRoom"],
        price: json["Price"],
        squareFootage: json["SquareFootage"],
        turnkeyPrice: json["TurnkeyPrice"],
        description: json["Description"],
        pictures: new List<String>.from(json["Pictures"].map((x) => x)),
      );

  Details.fromSnapshotJson(DataSnapshot snapshot) {
    acres = snapshot.value["Details"]["Acres"];
    units = snapshot.value["Details"]["Units"];
    bathRoom = snapshot.value["Details"]["BathRoom"];
    bedRoom = snapshot.value["Details"]["BedRoom"];
    price = snapshot.value["Details"]["Price"];
    squareFootage = snapshot.value["Details"]["SquareFootage"];
    turnkeyPrice = snapshot.value["Details"]["TurnkeyPrice"];
    description = snapshot.value["Details"]["Description"];
    pictures = new List<String>.from(
        snapshot.value["Details"]["Pictures"].map((x) => x));
  }

  Map<String, dynamic> toJson() =>
      {
        "Acres": acres,
        "Units": units,
        "BathRoom": bathRoom,
        "BedRoom": bedRoom,
        "Price": price,
        "SquareFootage": squareFootage,
        "TurnkeyPrice": turnkeyPrice,
        "Description": description,
        "Pictures": new List<dynamic>.from(pictures.map((x) => x)),
      };
}

class Location {
  String city;
  String state;

  Location({
    this.city,
    this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      new Location(
        city: json["City"],
        state: json["State"],
      );

  Location.fromSnapshotJson(DataSnapshot snapshot) {
    city = snapshot.value["Location"]["City"];
    state = snapshot.value["Location"]["State"];
  }

  Map<String, dynamic> toJson() =>
      {
        "City": city,
        "State": state,
      };
}
