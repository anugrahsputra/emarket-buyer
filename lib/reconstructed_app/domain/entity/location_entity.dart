import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double lat;
  final double long;

  const LocationEntity({
    this.lat = 0.0,
    this.long = 0.0,
  });

  @override
  List<Object> get props => [lat, long];
}
