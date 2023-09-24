import 'package:geolocator/geolocator.dart';

import '../../domain/domain.dart';
import '../data.dart';

class LocationRepositoryImpl extends LocationRepository {
  final RemoteDatasource datasource;
  LocationRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<String> getAddressFromLatLang(double lat, double lang) async {
    return datasource.getAddressFromLatLang(lat, lang);
  }

  @override
  Future<Position> getLocation() async {
    return datasource.getLocation();
  }
}
