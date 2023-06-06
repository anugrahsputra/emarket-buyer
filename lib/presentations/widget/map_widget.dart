import 'dart:async';
import 'dart:developer';

import 'package:emarket_buyer/common/common.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  List<LatLng> polylineCoordinates = [];

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      height: 350,
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
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('buyerLoc'),
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
                  color: Colors.greenAccent,
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
