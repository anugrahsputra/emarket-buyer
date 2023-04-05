import 'dart:async';

import 'package:emarket_buyer/models/location_model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChangeLocationPage extends StatefulWidget {
  const ChangeLocationPage({Key? key}) : super(key: key);

  @override
  State<ChangeLocationPage> createState() => _ChangeLocationPageState();
}

class _ChangeLocationPageState extends State<ChangeLocationPage> {
  final buyerController = Get.find<BuyerController>();
  final locationController = Get.find<LocationController>();

  late GoogleMapController mapController;
  StreamSubscription<Position>? positionStream;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  listenLocationChange() async {
    try {
      await locationController.checkPermission();

      positionStream = Geolocator.getPositionStream().listen(
        (Position position) {
          locationController.currentPosition = position;
        },
        cancelOnError: true,
      );
    } catch (e) {
      Get.snackbar('Error', 'Location service are disbled.');
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    listenLocationChange();
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Location'),
      ),
      body: GetBuilder<BuyerController>(
        builder: (controller) {
          final Set<Marker> markers = {
            Marker(
              markerId: const MarkerId('marker'),
              position: LatLng(buyerController.buyer.location.latitude,
                  buyerController.buyer.location.longitude),
              infoWindow: const InfoWindow(title: 'Lokasi Anda'),
            )
          };
          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  myLocationEnabled: true,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(buyerController.buyer.location.latitude,
                        buyerController.buyer.location.longitude),
                    zoom: 17.0,
                  ),
                  markers: markers,
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            LocationModel newLocation = LocationModel(
              latitude: locationController.currentPosition!.latitude,
              longitude: locationController.currentPosition!.longitude,
            );
            String address =
                await Get.find<LocationController>().getAddressFromLatLng(
              newLocation.latitude,
              newLocation.longitude,
            );
            await buyerController.updateUserLocation(
              newLocation,
              address,
            );
            Get.back();
          },
          child: const Text('Simpan'),
        ),
      ),
    );
  }
}
