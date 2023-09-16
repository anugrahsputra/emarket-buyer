import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_buyer/app/common/formatter.dart';
import 'package:emarket_buyer/app/models/model.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChekcoutPage extends StatelessWidget {
  ChekcoutPage({Key? key}) : super(key: key);

  final CheckoutController checkoutController = Get.put(CheckoutController());
  final CartController cartController = Get.put(CartController());
  final BuyerController buyerController = Get.put(BuyerController());
  final LocationController locationController = Get.put(LocationController());
  final AuthController auth = Get.put(AuthController());
  final TextEditingController noteController = TextEditingController();
  final TextEditingController additionalAddressController =
      TextEditingController();
  final Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              top: 10.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
            ),
            color: ColorScheme.fromSeed(seedColor: const Color(0xffa1cca5))
                .background,
            child: Column(
              children: [
                _buildText(
                  title: 'Total',
                  text: Formatter.priceFormat(cartController.total.toInt()),
                ),
                _buildText(
                  title: 'Ongkir',
                  text: 'Gratis',
                ),
                _buildText(
                  title: 'Jumlah Pesanan',
                  text: '${cartController.cartProducts.length} Item',
                ),
                const Divider(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              top: 10.h,
              bottom: 20.h,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Formatter.priceFormat(cartController.total.toInt()),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 130.w,
                  height: 50.h,
                  child: FilledButton(
                    onPressed: () async {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text(
                              'Pastikan alamat dan pesanan sudah benar'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                DateTime now = DateTime.now();
                                await checkoutController.newCheckout(
                                  CheckoutModel(
                                    buyerId: auth.user!.uid,
                                    sellerId: checkoutController.seller.id,
                                    isProcessing:
                                        checkoutController.isProcessing.value,
                                    isDelivered:
                                        checkoutController.isDelivered.value,
                                    isCancelled:
                                        checkoutController.isCancelled.value,
                                    isShipping:
                                        checkoutController.isShipping.value,
                                    displayName:
                                        buyerController.buyer.displayName,
                                    address: buyerController.buyer.address,
                                    location: buyerController.buyer.location,
                                    additionalAddress:
                                        additionalAddressController.text,
                                    cart: cartController.cartProducts,
                                    note: noteController.text,
                                    total: cartController.total.toInt(),
                                    date: DateFormat.yMMMMd()
                                        .add_Hm()
                                        .format(now),
                                    timestamp: Timestamp.fromDate(now),
                                  ),
                                );
                                Get.toNamed('/order-success-page');
                              },
                              child: const Text('Ya'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Pesan Sekarang',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          color: ColorScheme.fromSeed(seedColor: const Color(0xffa1cca5))
              .background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dikirim ke',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      buyerController.buyer.photoUrl,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buyerController.buyer.displayName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        buyerController.buyer.phoneNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              Text(
                'Alamat Delivery',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Obx(() {
                    return SizedBox(
                      width: 250.w,
                      child: Text(
                        buyerController.buyer.address,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.toNamed('/location-page');
                    },
                    icon: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: additionalAddressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Alamat tambahan (optional)\ncth: depan toko bunga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      style: BorderStyle.none,
                      width: 0,
                    ),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                'Catatan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hintText: 'Jangan terlalu pedas',
                  prefixIcon: const Icon(Icons.note_alt_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      style: BorderStyle.none,
                      width: 0,
                    ),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Item keranjang',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartController.cartProducts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                  cartController.cartProducts[index].imageUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartController.cartProducts[index].name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 18.h,
                              ),
                              Text(
                                'Rp. ${cartController.cartProducts[index].price * cartController.cartProducts[index].quantity}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            '${cartController.cartProducts[index].quantity}x',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildText({required String title, required String text}) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
          ),
        ),
        const Spacer(),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
