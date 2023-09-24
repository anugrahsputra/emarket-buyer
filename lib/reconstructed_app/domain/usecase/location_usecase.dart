import 'package:geolocator/geolocator.dart';

import '../domain.dart';

class Location {
  final LocationRepository repo;
  Location({
    required this.repo,
  });

  Future<Position> executeGetLocation() async => repo.getLocation();

  Future<String> executeGetAddress(double lat, double lang) async =>
      repo.getAddressFromLatLang(lat, lang);
}
