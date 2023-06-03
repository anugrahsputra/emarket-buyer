import 'dart:developer';

import 'package:emarket_buyer/services/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionController extends GetxController {
  final _directionRepo = DistanceMatrix();

  final origin = const LatLng(0, 0).obs;
  final destination = const LatLng(0, 0).obs;
  final distance = 0.obs;
  final duration = 0.obs;

  @override
  void onInit() {
    getDuration();
    super.onInit();
  }

  Future<void> getDuration() async {
    try {
      final response = await _directionRepo.getDirections(
        origin: origin.value,
        destination: destination.value,
      );
      log('response: $response');
      log('response distance: ${response.distance}');
      log('response duration: ${response.duration}');

      distance.value = response.distance;
      duration.value = response.duration;
      update();
    } catch (e) {
      log('dircontroller: $e');
      rethrow;
    }
  }
}
