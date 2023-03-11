import 'package:emarket_buyer/controller/controller.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChekcoutPage extends StatelessWidget {
  ChekcoutPage({Key? key}) : super(key: key);

  final CheckoutController checkoutController = Get.put(CheckoutController());
  final CartController cartController = Get.put(CartController());
  final BuyerController buyerController = Get.find<BuyerController>();
  final AuthController auth = Get.put(AuthController());
  Database database = Database();

  @override
  Widget build(BuildContext context) {
    return GetX<BuyerController>(
      init: buyerController,
      initState: (_) async {
        buyerController.buyer = await database.getBuyer(auth.user!.uid);
      },
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Checkout'),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp. ${cartController.total}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Bayar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp. ${cartController.total}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    buyerController.fetchBuyer();
                    checkoutController.newCheckout(
                      CheckoutModel(
                        displayName: buyerController.buyer.displayName,
                        cart: cartController.cartProducts,
                        total: cartController.total.toInt(),
                        date: checkoutController.formattedDate.value,
                      ),
                    );
                    await Get.dialog(
                      const AlertDialog(
                        title: Text('Hapus Produk'),
                        content: Text('Berhasil dipesan'),
                      ),
                    );
                    cartController.cartProducts.clear();
                    cartController.update();
                    Get.back();
                  },
                  child: const Text('Bayar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
