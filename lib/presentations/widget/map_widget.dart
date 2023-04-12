import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
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
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('buyer latitude: ${widget.buyer.location.latitude}');
    debugPrint('buyer longtitude: ${widget.buyer.location.longitude}');
    debugPrint('seller latittude: ${widget.seller.location.latitude}');
    debugPrint('seller latittude: ${widget.seller.location.longitude}');
    return Container(
      margin: const EdgeInsets.all(24),
      height: 420,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: GetBuilder<BuyerController>(
        builder: (controller) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  (widget.buyer.location.latitude +
                          widget.seller.location.latitude) /
                      2,
                  (widget.buyer.location.longitude +
                          widget.seller.location.longitude) /
                      2,
                ),
                zoom: 14.4746,
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
            ),
          );
        },
      ),
    );
  }
}
