import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller.dart';
import '../widget/product_card_widget.dart';

class Homepage extends StatelessWidget {
  Homepage({Key? key}) : super(key: key);

  final AuthController controller = Get.put(AuthController());
  final ProductController productController = Get.put(ProductController());
  final SellerController sellerController = Get.put(SellerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              controller.signOut();
            },
          )
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
              final defaultSeller = const SellerModel();
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
