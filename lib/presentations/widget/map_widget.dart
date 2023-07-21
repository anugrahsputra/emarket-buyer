import 'dart:async';
import 'dart:developer';

import 'package:emarket_buyer/common/common.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as IMG;

class MapWIdget extends StatefulWidget {
  const MapWIdget({
    super.key,
    required this.buyer,
    required this.seller,
  });
  final BuyerModel buyer;
  final SellerModel seller;

  @override
  State<MapWIdget> createState() => _MapWIdgetState();
}

class _MapWIdgetState extends State<MapWIdget> {
  final Completer<GoogleMapController> _controller = Completer();
  final MapController mapController = Get.find<MapController>();
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};

  Uint8List? resizeImage(Uint8List data, width, height) {
    Uint8List? resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!, width: width, height: height);
    resizedData = Uint8List.fromList(IMG.encodePng(resized));
    return resizedData;
  }

  void setMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icon/pin.png')
        .then((icon) => sourceIcon = icon);
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/icon/user.png')
        .then((icon) => destinationIcon = icon);
  }

  void getPolyline() async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(
          widget.buyer.location.latitude,
          widget.buyer.location.longitude,
        ),
        PointLatLng(
          widget.seller.location.latitude,
          widget.seller.location.longitude,
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
        setState(() {});
      }
    } catch (e) {
      log('Error retrieving polyline: $e');
    }
  }

  @override
  void initState() {
    getPolyline();
    setMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      height: 350.h,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: GetBuilder<BuyerController>(
        builder: (controller) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: GoogleMap(
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  (widget.buyer.location.latitude +
                          widget.seller.location.latitude) /
                      2,
                  (widget.buyer.location.longitude +
                          widget.seller.location.longitude) /
                      2,
                ),
                zoom: 14.6,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('buyerLoc'),
                  icon: destinationIcon,
                  position: LatLng(
                    widget.buyer.location.latitude,
                    widget.buyer.location.longitude,
                  ),
                  infoWindow: InfoWindow(
                    title: widget.buyer.displayName,
                    snippet: widget.buyer.address,
                  ),
                ),
                Marker(
                  markerId: const MarkerId('sellerLoc'),
                  icon: sourceIcon,
                  position: LatLng(
                    widget.seller.location.latitude,
                    widget.seller.location.longitude,
                  ),
                  infoWindow: InfoWindow(
                    title: widget.seller.displayName,
                    snippet: widget.seller.address,
                  ),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.redAccent,
                  geodesic: true,
                  jointType: JointType.round,
                  zIndex: 1,
                  width: 4,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
