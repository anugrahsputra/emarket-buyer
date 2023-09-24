import 'package:geolocator/geolocator.dart';

abstract class LocationRepository {
  Future<Position> getLocation();
  Future<String> getAddressFromLatLang(double lat, double lang);
}
