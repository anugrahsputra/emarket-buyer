import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final String? id;
  final double latitude;
  final double longitude;

  const LocationModel({
    this.id,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  LocationModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
  }) {
    return LocationModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [id, latitude, longitude];
}
