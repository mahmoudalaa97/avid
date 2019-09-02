class Post {
  String bringMeADeal;
  String userId;
  Details details;
  String joinVentureType;
  String listingType;
  Location location;
  String propertyType;
  String turnkeyListing;

  Post(
      {this.bringMeADeal,
      this.userId,
      this.details,
      this.joinVentureType,
      this.listingType,
      this.location,
      this.propertyType,
      this.turnkeyListing});

  Post.fromJson(Map<String, dynamic> json) {
    bringMeADeal = json['BringMeADeal'];
    userId = json['UserId'];
    details =
        json['Details'] != null ? new Details.fromJson(json['Details']) : null;
    joinVentureType = json['JoinVentureType'];
    listingType = json['ListingType'];
    location = json['Location'] != null
        ? new Location.fromJson(json['Location'])
        : null;
    propertyType = json['PropertyType'];
    turnkeyListing = json['TurnkeyListing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BringMeADeal'] = this.bringMeADeal;
    data['UserId'] = this.userId;
    if (this.details != null) {
      data['Details'] = this.details.toJson();
    }
    data['JoinVentureType'] = this.joinVentureType;
    data['ListingType'] = this.listingType;
    if (this.location != null) {
      data['Location'] = this.location.toJson();
    }
    data['PropertyType'] = this.propertyType;
    data['TurnkeyListing'] = this.turnkeyListing;
    return data;
  }
}

class Details {
  String acres;
  String bathRoom;
  String bedRoom;
  String description;
  String price;
  String squareFootage;
  String turnkeyPrice;
  String units;
  List<String> pictures;

  Details(
      {this.acres,
      this.bathRoom,
      this.bedRoom,
      this.description,
      this.price,
      this.squareFootage,
      this.turnkeyPrice,
      this.units,
      this.pictures});

  Details.fromJson(Map<String, dynamic> json) {
    acres = json['Acres'];
    bathRoom = json['BathRoom'];
    bedRoom = json['BedRoom'];
    description = json['Description'];
    price = json['Price'];
    squareFootage = json['SquareFootage'];
    turnkeyPrice = json['TurnkeyPrice'];
    units = json['Units'];
    pictures = json['Pictures'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Acres'] = this.acres;
    data['BathRoom'] = this.bathRoom;
    data['BedRoom'] = this.bedRoom;
    data['Description'] = this.description;
    data['Price'] = this.price;
    data['SquareFootage'] = this.squareFootage;
    data['TurnkeyPrice'] = this.turnkeyPrice;
    data['Units'] = this.units;
    data['Pictures'] = this.pictures;
    return data;
  }
}

class Location {
  String city;
  String state;

  Location({this.city, this.state});

  Location.fromJson(Map<String, dynamic> json) {
    city = json['City'];
    state = json['State'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['City'] = this.city;
    data['State'] = this.state;
    return data;
  }
}
