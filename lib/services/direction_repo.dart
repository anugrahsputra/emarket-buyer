import 'package:dio/dio.dart';
import 'package:emarket_buyer/common/common.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// NOTE: Distnace Matrix will not working because I don't activate google map billing

enum TravelMode { driving, walking, bicycling, transit }

class DirectionRepo {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json?';

  final Dio _dio;

  DirectionRepo({Dio? dio}) : _dio = dio ?? Dio();

  Future<DirectionResponse> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final params = <String, dynamic>{
      'origins': '${origin.latitude},${origin.longitude}',
      'destinations': '${destination.latitude},${destination.longitude}',
      'units': 'metric',
      'key': googleApiKey,
    };

    final response = await _dio.get(_baseUrl, queryParameters: params);

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String;

      if (status == 'OK') {
        final rows = data['rows'] as List<dynamic>;

        if (rows.isNotEmpty) {
          final elements = rows[0]['elements'] as List<dynamic>;

          if (elements.isNotEmpty) {
            final distance = elements[0]['distance']['value'] as int;
            final duration = elements[0]['duration']['value'] as int;

            return DirectionResponse(distance: distance, duration: duration);
          }
        }
      }

      final errorMessage = data['error_message'] as String?;
      throw Exception('Failed to load directions. Reason: $errorMessage');
    } else {
      throw Exception('Failed to load directions');
    }
  }
}

class DirectionResponse {
  final int distance;
  final int duration;

  DirectionResponse({required this.distance, required this.duration});

  double get distanceInKm => distance / 1000;
  double get durationInMinutes => duration / 60;
}
