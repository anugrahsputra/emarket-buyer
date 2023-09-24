import '../../domain/domain.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    double lat = 0.0,
    double long = 0.0,
  }) : super(lat: lat, long: long);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'lat': lat,
      'long': long,
    };
  }
}
