import 'package:badges/badges.dart' as badges;
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/pages/detail_page.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// *note: Need a better UX for this page
// todo: Make a list of Sellers instead of a list of Products

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);

  final AuthController controller = Get.put(AuthController());
  final ProductController productController = Get.put(ProductController());
  final SellerController sellerController = Get.put(SellerController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
            icon: Obx(
              () => badges.Badge(
                badgeContent: Text(
                  cartController.cartProducts.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                showBadge:
                    cartController.cartProducts.isNotEmpty ? true : false,
                badgeAnimation: const badges.BadgeAnimation.rotation(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                  curve: Curves.fastOutSlowIn,
                  colorChangeAnimationCurve: Curves.easeInCubic,
                ),
                child: const Icon(Icons.shopping_bag_rounded),
              ),
            ),
            onPressed: () {
              Get.toNamed('/cart-page');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (productController.product.isEmpty) {
          return const Center(
            child: Text('Tidak ada produk'),
          );
        } else if (productController.loading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: productController.product.length,
            itemBuilder: (context, index) {
              const defaultSeller = SellerModel();
              final product = productController.product[index];
              final seller = sellerController.seller.firstWhere(
                (element) => element.id == product.sellerId,
                orElse: () => defaultSeller,
              );
              return GestureDetector(
                onTap: () async {
                  Get.to(
                    () => DetailPage(
                      product: product,
                      seller: seller,
                    ),
                  );
                },
                child: ProductCard(
                  product: productController.product[index],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
