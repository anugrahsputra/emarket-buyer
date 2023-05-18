import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/services/services.dart';
import 'package:flutter/material.dart';
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
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            color: ColorScheme.fromSeed(seedColor: const Color(0xffa1cca5))
                .background,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Rp. ${cartController.total.toInt()}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Ongkir',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Gratis',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: 20,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rp. ${cartController.total.toInt()}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pesanan anda (${cartController.cartProducts.length} item)',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 160,
                  height: 60,
                  child: FilledButton(
                    onPressed: () async {
                      await checkoutController.newCheckout(
                        CheckoutModel(
                          buyerId: auth.user!.uid,
                          sellerId: checkoutController.seller.id,
                          isProcessing: checkoutController.isProcessing.value,
                          isDelivered: checkoutController.isDelivered.value,
                          isCancelled: checkoutController.isCancelled.value,
                          displayName: buyerController.buyer.displayName,
                          cart: cartController.cartProducts,
                          note: noteController.text,
                          total: cartController.total.toInt(),
                          date: DateFormat.yMMMMd().format(DateTime.now()),
                        ),
                      );
                      Get.toNamed('/order-success-page');
                    },
                    child: const Text('Pesan Sekarang'),
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      buyerController.buyer.photoUrl,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
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
              const SizedBox(
                height: 24,
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
                      width: 250,
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
              const SizedBox(height: 15),
              Text(
                'Catatan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
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
              const SizedBox(
                height: 40,
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
                            width: 100,
                            height: 100,
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
                          const SizedBox(
                            width: 10,
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
                              const SizedBox(
                                height: 18,
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
}
