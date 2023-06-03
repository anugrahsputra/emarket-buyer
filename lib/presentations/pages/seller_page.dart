import 'dart:async';

import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SellerPage extends StatelessWidget {
  SellerPage({Key? key, required this.seller}) : super(key: key);

  final SellerModel seller;

  final Completer<GoogleMapController> _controller = Completer();

  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: GoogleMap(
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                minMaxZoomPreference: const MinMaxZoomPreference(1, 20),
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    seller.location.latitude,
                    seller.location.longitude,
                  ),
                  zoom: 16.7,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('seller'),
                    position: LatLng(
                      seller.location.latitude,
                      seller.location.longitude,
                    ),
                  ),
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seller.storeName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    seller.address,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    seller.phoneNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    seller.email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productController.product.length,
              itemBuilder: (context, index) {
                final product = productController.product[index];
                if (product.sellerId == seller.id) {
                  return ListTile(
                    onTap: () {
                      Get.to(() => DetailPage(
                            product: product,
                            seller: seller,
                          ));
                    },
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: Text(
                      'Rp. ${product.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
