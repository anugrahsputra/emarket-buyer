import 'package:carbon_icons/carbon_icons.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({super.key, required this.checkout, required this.seller});

  final CheckoutModel checkout;
  final SellerModel seller;
  final BuyerController buyerController = Get.put(BuyerController());
  final SellerController sellerController = Get.put(SellerController());
  final CheckoutController checkoutContoller = Get.put(CheckoutController());
  final DirectionController directionController =
      Get.put(DirectionController());

  @override
  Widget build(BuildContext context) {
    directionController.origin.value = LatLng(
        buyerController.buyer.location.latitude,
        buyerController.buyer.location.longitude);
    directionController.destination.value =
        LatLng(seller.location.latitude, seller.location.longitude);
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
                  Get.back();
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

  buildProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            Row(
              children: [
                const Icon(MdiIcons.packageUp, color: Colors.green),
                Container(
                  width: 60,
                  height: 2,
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
                  width: 60,
                  height: 2,
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
                  width: 60,
                  height: 2,
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
            const SizedBox(width: 24),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  buildOrderContents() {
    return Column(
      children: [
        MapWIdget(
          buyer: buyerController.buyer,
          seller: seller,
        ),
        buildProgress(),
        buildSellerInfo(),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                'Estimasi Waktu Sampai: ',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Obx(
                () => Text(
                  '${directionController.duration.value} menit',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  buildSellerInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
              height: 50,
              width: 50,
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
