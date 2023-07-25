import 'dart:developer';

import 'package:carbon_icons/carbon_icons.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({
    super.key,
    required this.checkout,
    required this.seller,
  });

  final CheckoutModel checkout;
  final SellerModel seller;
  final BuyerController buyerController = Get.put(BuyerController());
  final SellerController sellerController = Get.put(SellerController());
  final CheckoutController checkoutContoller = Get.put(CheckoutController());
  final ProductController productController = Get.put(ProductController());
  final DirectionController directionController =
      Get.put(DirectionController());

  @override
  Widget build(BuildContext context) {
    directionController.destination.value = LatLng(
      seller.location.latitude,
      seller.location.longitude,
    );
    directionController.origin.value = LatLng(
      buyerController.buyer.location.latitude,
      buyerController.buyer.location.longitude,
    );
    log('seller: ${seller.location.latitude} ${seller.location.longitude}');
    log('buyer: ${buyerController.buyer.location.latitude} ${buyerController.buyer.location.longitude}');

    return GetBuilder<DirectionController>(
      init: directionController,
      initState: (_) {
        directionController.getDuration();
      },
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Pesanan'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: checkout.isShipping == true
                    ? checkout.isDelivered == true
                        ? Container()
                        : button(context)
                    : Container(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: buildOrderContents(),
          ),
        );
      },
    );
  }

  buildOrderContents() {
    log('origin: ${directionController.origin.value}');
    log('destination: ${directionController.destination.value}');
    final durationFormatted = directionController.duration.value >= 3600
        ? '${(directionController.duration.value ~/ 3600)} jam ${(directionController.duration.value % 3600) ~/ 60} menit'
        : '${(directionController.duration.value ~/ 60)} menit';
    return Column(
      children: [
        MapWIdget(
          buyer: buyerController.buyer,
          seller: seller,
        ),
        buildProgress(),
        buildSellerInfo(),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Row(
            children: [
              Text(
                'Estimasi Waktu Sampai: ',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                durationFormatted,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        buildProductList(),
      ],
    );
  }

  button(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Terima pesanan?',
              style: GoogleFonts.plusJakartaSans(),
            ),
            content: Text(
              'Sebelum menyelesaikan pesanan, pastikan ada kamu sudah menerima dan membayar produknya ya',
              style: GoogleFonts.plusJakartaSans(),
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Map<String, dynamic> data = {
                    'isDelivered': true,
                  };
                  checkoutContoller.updateStatus(checkout, data);
                  Get.back();

                  Get.off(() => RateScreen(checkout: checkout, seller: seller));
                },
                child: Text(
                  'Terima',
                  style: GoogleFonts.plusJakartaSans(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Nanti dulu',
                  style: GoogleFonts.plusJakartaSans(),
                ),
              ),
            ],
          ),
        );
      },
      icon: const Icon(MdiIcons.packageCheck),
      label: const Text('Selesai'),
    );
  }

  buildProductList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: checkout.cart.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: ListTile(
            leading: Image.network(
              checkout.cart[index].imageUrl,
            ),
            title: Text(
              checkout.cart[index].name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              checkout.cart[index].price.toString(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
              ),
            ),
            trailing: Text(
              checkout.cart[index].quantity.toString(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  buildProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24.w),
            Row(
              children: [
                const Icon(MdiIcons.packageUp, color: Colors.green),
                Container(
                  width: 60.w,
                  height: 2.h,
                  color: checkout.isProcessing == true
                      ? Colors.green
                      : Colors.grey,
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  CarbonIcons.package,
                  color: checkout.isProcessing == true
                      ? Colors.green
                      : Colors.grey,
                ),
                Container(
                  width: 60.w,
                  height: 2.h,
                  color:
                      checkout.isShipping == true ? Colors.green : Colors.grey,
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  CarbonIcons.delivery_parcel,
                  color:
                      checkout.isShipping == true ? Colors.green : Colors.grey,
                ),
                Container(
                  width: 60.w,
                  height: 2.h,
                  color:
                      checkout.isDelivered == true ? Colors.green : Colors.grey,
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  CarbonIcons.checkmark,
                  color:
                      checkout.isDelivered == true ? Colors.green : Colors.grey,
                ),
              ],
            ),
            SizedBox(width: 24.w),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  buildSellerInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(seller.photoUrl, scale: 1),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seller.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                seller.storeName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () async {
              // final int index = checkout.cart
              //     .indexWhere((element) => element.sellerId == seller.id);
              // launchWhatsapp(
              //   seller.phoneNumber,
              //   'Halo ${seller.displayName}, tadi saya memesan ${checkout.cart[index].name} item dari toko ${seller.storeName} di eMarket. Mohon konfirmasi pesanan saya.\n \n Terima kasih.',
              // );
              MapsLauncher.launchCoordinates(
                  seller.location.latitude, seller.location.longitude);
            },
            icon: Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: const Color(0xffb5c99a),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.phone,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void launchWhatsapp(String phoneNumber, String message) async {
    String url = "whatsapp://send?phone=$phoneNumber&text=$message";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
