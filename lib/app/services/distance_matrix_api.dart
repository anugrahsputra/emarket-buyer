import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:emarket_buyer/app/common/common.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// NOTE: Distnace Matrix will not working because I don't activate google map billing

enum TravelMode { driving, walking, bicycling, transit }

class DistanceMatrix {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json?';

  final Dio _dio;

  DistanceMatrix({Dio? dio}) : _dio = dio ?? Dio();

  Future<DistanceMatrixResponse> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final params = <String, dynamic>{
      'origins': '${origin.latitude},${origin.longitude}',
      'destinations': '${destination.latitude},${destination.longitude}',
      'units': 'imperial',
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
            final element = elements[0] as Map<String, dynamic>;
            final elementStatus = element['status'] as String;

            if (elementStatus == 'OK') {
              final distanceObject = element['distance'];
              final durationObject = element['duration'];

              if (distanceObject != null && durationObject != null) {
                final distance = distanceObject['value'] as int;
                final duration = durationObject['value'] as int;

                return DistanceMatrixResponse(
                    distance: distance, duration: duration);
              }
            }
          }
        }
      } else if (status == 'ZERO_RESULTS') {
        // Handle the case when no route is found
        return DistanceMatrixResponse(distance: 0, duration: 0);
      }

      final errorMessage = data['error_message'] as String?;
      final reason = errorMessage ?? 'Unknown error';
      log('Direction API Response: $data'); // Print the response data for debugging
      throw Exception('Failed to load directions. Reason: $reason');
    } else {
      throw Exception('Failed to load directions');
    }
  }
}

class DistanceMatrixResponse {
  final int distance;
  final int duration;

  DistanceMatrixResponse({required this.distance, required this.duration});

  double get distanceInKm => distance / 1000;

  String get durationText {
    final int hours = duration ~/ 3600;
    final int minutes = (duration % 3600) ~/ 60;

    if (hours == 0) {
      return '$minutes menit';
    } else {
      return '$hours jam $minutes menit';
    }
  }
}
