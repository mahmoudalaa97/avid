import 'package:geocoder/geocoder.dart';

abstract class BaseGeoLocation {
  Future<Coordinates> getLocationQuery(String query);
}

class GeoLocation implements BaseGeoLocation {
  @override
  Future<Coordinates> getLocationQuery(String query) async {
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      print("${addresses.first.coordinates}");
      return addresses.first.coordinates;
    } catch (e) {}
    return Coordinates(0, 0);
  }
}
