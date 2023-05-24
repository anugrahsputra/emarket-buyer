import 'package:emarket_buyer/services/direction_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionController extends GetxController {
  final _directionRepo = DirectionRepo();

  final origin = const LatLng(0, 0).obs;
  final destination = const LatLng(0, 0).obs;
  final distance = 0.obs;
  final duration = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getDuration();
  }

  Future<void> getDuration() async {
    try {
      final response = await _directionRepo.getDirections(
        origin: origin.value,
        destination: destination.value,
      );
      distance.value = response.distance;
      duration.value = response.duration;
    } catch (e) {
      debugPrint('dircontroller: $e');
      distance.value = 0;
      duration.value = 0;
    }
  }
}
