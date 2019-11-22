import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String userUid;
  String fullName;
  String username;
  YourLocation yourLocation;
  String email;
  String profilePicture;
  Timestamp timeCreate;
  User({
    this.userUid,
    this.fullName,
    this.username,
    this.yourLocation,
    this.email,
    this.profilePicture,
    this.timeCreate
  });

  User.fromDocument(DocumentSnapshot documentSnapshot){
    userUid = documentSnapshot.data["userUid"];
    fullName = documentSnapshot.data["FullName"];
    username = documentSnapshot.data["Username"];
    yourLocation = YourLocation.fromDocument(documentSnapshot);
    email = documentSnapshot.data["Email"];
    profilePicture = documentSnapshot.data["ProfilePicture"];
    timeCreate = documentSnapshot.data["Created_At"] as Timestamp;
  }

  factory User.fromJson(Map<String, dynamic> json) => new User(
        userUid: json["userUid"],
        fullName: json["FullName"],
        username: json["Username"],
        yourLocation: YourLocation.fromJson(json["YourLocation"]),
        email: json["Email"],
        profilePicture: json["ProfilePicture"],
      timeCreate: json["TimeCreate"]
      );

  User.fromSnapshotJson(DataSnapshot snapshot) {
    userUid = snapshot.value["userUid"];
    fullName = snapshot.value["FullName"];
    username = snapshot.value["Username"];
    yourLocation = YourLocation.fromSnapshotJson(snapshot);
    email = snapshot.value["Email"];
    profilePicture = snapshot.value["ProfilePicture"];
    timeCreate = snapshot.value["Created_At"];
  }

  Map<String, dynamic> toJson() => {
        "userUid": userUid,
        "FullName": fullName,
        "Username": username,
        "YourLocation": yourLocation.toJson(),
        "Email": email,
        "ProfilePicture": profilePicture,
    "Created_At": timeCreate.millisecondsSinceEpoch
      };
}

class YourLocation {
  String city;
  String state;

  YourLocation({
    this.city,
    this.state,
  });

  factory YourLocation.fromJson(Map<String, dynamic> json) => new YourLocation(
        city: json["City"],
        state: json["State"],
      );

  YourLocation.fromSnapshotJson(DataSnapshot snapshot) {
    city = snapshot.value["YourLocation"]["City"];
    state = snapshot.value["YourLocation"]["State"];
  }

  YourLocation.fromDocument(DocumentSnapshot snapshot) {
    city = snapshot.data["YourLocation"]["City"];
    state = snapshot.data["YourLocation"]["State"];
  }

  Map<String, dynamic> toJson() => {
        "City": city,
        "State": state,
      };
}
