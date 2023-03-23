import 'dart:developer';

import 'package:emarket_buyer/models/model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final Geolocator geolocator = Geolocator();
  late Rx<LocationModel> location;

  Position? currentPosition;

  @override
  void onInit() {
    super.onInit();
    location = Rx<LocationModel>(const LocationModel(
      latitude: 0.0,
      longitude: 0.0,
    ));
    getCurrentLocation();
  }

  Future checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    try {
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      return Future.error('Location service are disbled.');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      await checkPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      location.value = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng, localeIdentifier: 'id');
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            "${placemark.street}, ${placemark.locality}, ${placemark.subLocality}";
        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Error getting address: $e";
    }
  }
}
