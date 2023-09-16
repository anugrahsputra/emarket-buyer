import 'package:emarket_buyer/app/common/formatter.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:emarket_buyer/app/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Cartpage extends StatelessWidget {
  static const String routeName = '/cart-page';
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
                  shrinkWrap: true,
                  itemCount: cartController.cartProducts.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(cartController.cartProducts[index].productId),
                      background: Container(
                        height: 110.h,
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
                          cartController.cartProducts[index].productId,
                        );
                        Fluttertoast.showToast(
                          msg:
                              '${cartController.cartProducts[index].name} berhasil dihapus',
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
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 5000),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 20.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffb5c99a),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  Formatter.priceFormat(cartController.total.value),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
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
      ),
    );
  }
}
