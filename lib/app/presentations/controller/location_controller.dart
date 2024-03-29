import 'dart:async';
import 'dart:developer';

import 'package:emarket_buyer/app/helper/helper.dart';
import 'package:emarket_buyer/app/models/model.dart';
import 'package:emarket_buyer/app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  Geolocator geolocator = Geolocator();
  PlacesService placesService = PlacesService();
  GeofencingHelper geofencingHelper = GeofencingHelper();
  final addressSuggestions = <Map<String, dynamic>>[].obs;
  late Rx<LocationModel> location;
  bool isInsideGeoFence = true;
  final loading = false.obs;

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

  setLoading(bool value) {
    loading.value = value;
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
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      return Future.error('Location service are disbled.');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      await checkPermission();
      setLoading(true);
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      location.value = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      setLoading(false);
    } catch (e) {
      setLoading(false);
      debugPrint(e.toString());
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng, localeIdentifier: 'id');
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}";
        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Error getting address: $e";
    }
  }

  Future<void> autocompleteAddress(String query) async {
    try {
      final suggestions = await placesService.placeAutocomplete(query);
      addressSuggestions.value = suggestions;
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<LatLng> getCoordinatesFromPlaceId(String placeId) async {
    try {
      final coordinates =
          await placesService.getCoordinatesFromPlaceId(placeId);
      return coordinates;
    } catch (e) {
      debugPrint(e.toString());
      return const LatLng(0.0, 0.0);
    }
  }

  Future<void> getCurrentPosition() async {
    try {
      await checkPermission();
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        currentPosition = position;
        location.value = LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        final bool isInside =
            GeofencingHelper.isPositionInsideGeofence(position);
        if (isInside != isInsideGeoFence) {
          isInsideGeoFence = isInside;
          log('isInsideGeoFence: $isInsideGeoFence');
          update();
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
