import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String userUid;
  String fullName;
  String username;
  YourLocation yourLocation;
  String email;
  String profilePicture;

  User({
    this.userUid,
    this.fullName,
    this.username,
    this.yourLocation,
    this.email,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        userUid: json["userUid"],
        fullName: json["FullName"],
        username: json["Username"],
        yourLocation: YourLocation.fromJson(json["YourLocation"]),
        email: json["Email"],
        profilePicture: json["ProfilePicture"],
      );

  User.fromSnapshotJson(DataSnapshot snapshot) {
    userUid = snapshot.value["userUid"];
    fullName = snapshot.value["FullName"];
    username = snapshot.value["Username"];
    yourLocation = YourLocation.fromSnapshotJson(snapshot);
    email = snapshot.value["Email"];
    profilePicture = snapshot.value["ProfilePicture"];
  }

  Map<String, dynamic> toJson() => {
        "userUid": userUid,
        "FullName": fullName,
        "Username": username,
        "YourLocation": yourLocation.toJson(),
        "Email": email,
        "ProfilePicture": profilePicture,
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

  Map<String, dynamic> toJson() => {
        "City": city,
        "State": state,
      };
}
