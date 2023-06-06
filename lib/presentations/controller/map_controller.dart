import 'dart:developer';

import 'package:emarket_buyer/common/common.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  List<LatLng> polylineCoordinates = [];
  final BuyerController buyerController = Get.find<BuyerController>();
  final SellerController sellerController = Get.find<SellerController>();

  @override
  void onInit() {
    super.onInit();
    getPolyline();
  }

  void getPolyline() async {
    await buyerController.fetchBuyer();
    sellerController.fetchSellers();
    try {
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(
          buyerController.buyer.location.latitude,
          buyerController.buyer.location.longitude,
        ),
        PointLatLng(
          sellerController.sellerModel.location.latitude,
          sellerController.sellerModel.location.longitude,
        ),
        travelMode: TravelMode.walking,
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
        log('Polyline coordinates: $polylineCoordinates');
        update();
      }
    } catch (e) {
      // Handle any errors that occur during the polyline retrieval process
      log('Error retrieving polyline: $e');
    }
  }
}
