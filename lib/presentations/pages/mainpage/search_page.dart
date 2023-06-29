import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends GetWidget<QueryController> {
  SearchPage({Key? key}) : super(key: key);
  final SellerController sellerController = Get.find<SellerController>();
  final TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: queryController,
              onChanged: (value) {
                controller.updateQuery(value);
              },
              decoration: const InputDecoration(
                hintText: 'Cari barang',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return buildSearchLoading();
              } else {
                if (controller.queryString.isEmpty) {
                  return Center(
                    child: Text(
                      'Cari produk yang kamu mau',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                } else if (controller.searchResult.isEmpty) {
                  return Center(
                    child: Text(
                      'Aduh, ${queryController.text} sepertinya belum ada :(',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.searchResult.length,
                    itemBuilder: (context, index) {
                      final product = controller.searchResult[index];
                      final seller = sellerController.sellers.firstWhere(
                        (seller) => seller.id == product.sellerId,
                        orElse: () => const SellerModel(),
                      );
                      return GestureDetector(
                        onTap: () {
                          Get.to(() =>
                              DetailPage(product: product, seller: seller));
                        },
                        child: ProductCard(product: product, seller: seller),
                      );
                    },
                  );
                }
              }
            }),
          ),
        ],
      ),
    );
  }

  buildSearchLoading() {
    return Center(
      child: Lottie.asset(
        'assets/lottie/search.json',
      ),
    );
  }
}
