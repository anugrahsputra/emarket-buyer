import 'package:dio/dio.dart';
import 'package:emarket_buyer/common/common.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  final String _baseUrl = Env.baseUrl;
  final String _autoComplete = Env.autoComplete;
  final String _details = Env.details;
  final String googleApiKey = Env.apiKey;
  final Dio _dio;

  PlacesService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Map<String, dynamic>>> placeAutocomplete(String query) async {
    // latlng in Bandung
    const latitude = -6.917464;
    const longitude = 107.619123;
    const radius = 50000;
    try {
      final response = await _dio.get(
        '$_baseUrl$_autoComplete',
        queryParameters: {
          "input": query,
          "key": googleApiKey,
          "types": "establishment",
          "language": "id",
          "components": "country:id",
          "location": "$latitude,$longitude",
          "radius": "$radius",
          "strictbounds": "",
        },
      );
      if (response.statusCode == 200) {
        final predictions = response.data['predictions'] as List;
        List<Map<String, dynamic>> suggestions = [];

        for (var prediction in predictions) {
          suggestions.add({
            'place_id': prediction['place_id'],
            'description': prediction['description'],
          });
        }

        return suggestions;
      } else {
        throw Exception('Failed to fetch autocomplete suggestions');
      }
    } catch (e) {
      throw Exception('Failed to fetch autocomplete suggestions');
    }
  }

  Future<LatLng> getCoordinatesFromPlaceId(String placeId) async {
    try {
      final response = await Dio().get(
        '$_baseUrl$_details',
        queryParameters: {
          "place_id": placeId,
          "key": googleApiKey,
          "language": "id",
          "components": "country:id",
        },
      );
      if (response.statusCode == 200) {
        var data = response.data;
        var location = data['result']['geometry']['location'];
        double latitude = location['lat'];
        double longitude = location['lng'];
        return LatLng(latitude, longitude);
      } else {
        throw Exception('Failed to get coordinates from place_id');
      }
    } catch (e) {
      throw Exception('Failed to get coordinates from place_id');
    }
  }
}
