import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                return buildTextLoading();
              } else {
                if (controller.queryString.isEmpty) {
                  return const Center(
                    child: Text('Cari produk yang kamu mau'),
                  );
                } else if (controller.searchResult.isEmpty) {
                  return Center(
                    child: Text(
                        'Aduh, ${queryController.text} sepertinya belum ada :('),
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

  Center buildTextLoading() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Bentar ya, lagi dicari'),
          AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText('...'),
              WavyAnimatedText('...'),
              WavyAnimatedText('...'),
            ],
            isRepeatingAnimation: true,
            onTap: () {
              debugPrint("Tap Event");
            },
          ),
        ],
      ),
    );
  }
}
