import 'package:emarket_buyer/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Cartpage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  Cartpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: cartController,
      builder: (cartController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Keranjang'),
          ),
          body: cartController.cartProducts.isEmpty
              ? const Center(
                  child: Text('Tidak ada produk'),
                )
              : ListView.builder(
                  itemCount: cartController.cartProducts.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(cartController.cartProducts[index].productId),
                      background: Container(
                        height: 110,
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await Get.dialog(
                          AlertDialog(
                            title: const Text('Hapus Produk'),
                            content: const Text(
                                'Apakah anda yakin ingin menghapus produk ini?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back(result: false);
                                },
                                child: const Text('Tidak'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back(result: true);
                                },
                                child: const Text('Ya'),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        cartController.removeProduct(
                            cartController.cartProducts[index].productId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${cartController.cartProducts[index].name} berhasil dihapus',
                            ),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(50),
                            duration: const Duration(milliseconds: 1500),
                          ),
                        );
                      },
                      child: CartCard(
                        cartModel: cartController.cartProducts[index],
                        onPressedPlus: () {
                          cartController.increaseQuantity(index);
                        },
                        onPressedMin: () {
                          cartController.decreaseQuantity(index);
                        },
                      ),
                    );
                  },
                ),
          bottomNavigationBar: cartController.cartProducts.isEmpty
              ? null
              : buildCheckout(cartController, context),
        );
      },
    );
  }

  buildCheckout(CartController cartController, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 5000),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 15,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffb5c99a),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Total:',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Rp. ${cartController.total.value}',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            transform: cartController.cartProducts.isEmpty
                ? Matrix4.translationValues(
                    100,
                    0,
                    0,
                  )
                : Matrix4.translationValues(
                    0,
                    0,
                    0,
                  ),
            child: FilledButton.icon(
              onPressed: () {
                Get.toNamed('/checkout-page');
              },
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
