import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeofencingHelper {
  static final List<LatLng> _geofenceBoundary = [
    const LatLng(-6.171094, 106.759639),
    const LatLng(-6.204581, 106.811705),
    const LatLng(-6.209316, 106.860443),
    const LatLng(-6.161994, 106.867252),
    const LatLng(-6.130329, 106.823253),
    const LatLng(-6.132424, 106.776518),
    const LatLng(-6.171094, 106.759639),
  ];

  static bool isPositionInsideGeofence(Position position) {
    final double latitude = position.latitude;
    final double longitude = position.longitude;

    bool isInside = false;

    for (int i = 0, j = _geofenceBoundary.length - 1;
        i < _geofenceBoundary.length;
        j = i++) {
      if ((_geofenceBoundary[i].longitude > longitude) !=
              (_geofenceBoundary[j].longitude > longitude) &&
          (latitude <
              (_geofenceBoundary[j].latitude - _geofenceBoundary[i].latitude) *
                      (longitude - _geofenceBoundary[i].longitude) /
                      (_geofenceBoundary[j].longitude -
                          _geofenceBoundary[i].longitude) +
                  _geofenceBoundary[i].latitude)) {
        isInside = !isInside;
      }
    }

    return isInside;
  }
}
