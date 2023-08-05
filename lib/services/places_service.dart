import 'package:dio/dio.dart';
import 'package:emarket_buyer/common/common.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  static const String _baseUrl = 'https://maps.googleapis.com';
  static const String _autoComplete = '/maps/api/place/autocomplete/json';
  static const String _details = '/maps/api/place/details/json';

  final Dio _dio;

  PlacesService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Map<String, dynamic>>> placeAutocomplete(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl$_autoComplete',
        queryParameters: {
          "input": query,
          "key": googleApiKey,
          "types": "establishment",
          "language": "id",
          "components": "country:id",
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
