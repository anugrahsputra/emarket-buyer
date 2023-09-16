import 'dart:async';

import 'package:emarket_buyer/app/models/location_model.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  final TextEditingController _searchController = TextEditingController();

  late GoogleMapController mapController;
  StreamSubscription<Position>? positionStream;
  late LatLng selectedLocation;
  String searchAddress = '';
  List<Map<String, dynamic>> addressSuggestions = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updateLocation(LatLng newLatLng) {
    setState(() {
      selectedLocation = newLatLng;
    });
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
    selectedLocation = LatLng(
      buyerController.buyer.location.latitude,
      buyerController.buyer.location.longitude,
    );
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
        title: searchAddressField(),
      ),
      body: GetBuilder<BuyerController>(
        builder: (controller) {
          final Set<Marker> markers = {
            Marker(
              markerId: const MarkerId('current'),
              position: selectedLocation,
            ),
          };
          return Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: _onMapCreated,
                onTap: (newLatLng) {
                  _updateLocation(newLatLng);
                },
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(buyerController.buyer.location.latitude,
                      buyerController.buyer.location.longitude),
                  zoom: 17.0,
                ),
                markers: markers,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: FilledButton(
                  onPressed: () async {
                    if (_searchController.text.isNotEmpty) {
                      String address = locationController.addressSuggestions
                          .firstWhere(
                            (element) =>
                                element['description'] ==
                                _searchController.text,
                          )['description']
                          .toString();
                      await buyerController.updateUserLocation(
                        LocationModel(
                          latitude: selectedLocation.latitude,
                          longitude: selectedLocation.longitude,
                        ),
                        address,
                      );
                      Get.back();
                    } else {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Gunakan alamat yang sudah ada?'),
                          content: const Text(
                              'Alamat akan ditujukan sesuai dengan posisi kamu saat ini'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Get.back();
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                String address = await locationController
                                    .getAddressFromLatLng(
                                  locationController.currentPosition!.latitude,
                                  locationController.currentPosition!.longitude,
                                );
                                await buyerController.updateUserLocation(
                                  LocationModel(
                                    latitude: locationController
                                        .currentPosition!.latitude,
                                    longitude: locationController
                                        .currentPosition!.longitude,
                                  ),
                                  address,
                                );
                                Get.back();
                                Get.back();
                              },
                              child: const Text('Ya'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  searchAddressField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _searchController,
          onChanged: (value) {
            locationController.autocompleteAddress(value);
          },
          decoration: InputDecoration(
            hintText: 'Cari alamat...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
          ),
        ),
        suggestionsCallback: (String pattern) async {
          String lowerCasePattern = pattern.toLowerCase();
          return locationController.addressSuggestions
              .where((element) => element['description']
                  .toLowerCase()
                  .contains(lowerCasePattern))
              .toList();
          // return addressSuggestions
          //     .where((element) => element['description']
          //         .toLowerCase()
          //         .contains(lowerCasePattern))
          //     .toList();
        },
        itemBuilder: (context, Map<String, dynamic> suggestion) {
          return ListTile(
            title: Text(suggestion['description']),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          );
        },
        onSuggestionSelected: (suggestion) async {
          _searchController.text = suggestion['description'];
          LatLng newLatLng = await locationController
              .getCoordinatesFromPlaceId(suggestion['place_id']);
          // LatLng newLatLng =
          //     await getCoordinatesFromPlaceId(suggestion['place_id']);
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(newLatLng.latitude, newLatLng.longitude),
                zoom: 17.0,
              ),
            ),
          );
          _updateLocation(newLatLng);
        },
      ),
    );
  }
}
