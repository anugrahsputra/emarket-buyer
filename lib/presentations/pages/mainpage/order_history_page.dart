import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryPage extends StatelessWidget {
  OrderHistoryPage({Key? key}) : super(key: key);

  final CheckoutController checkoutController = Get.put(CheckoutController());
  final SellerController sellerController = Get.put(SellerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: GetBuilder<CheckoutController>(
        init: checkoutController,
        initState: (_) {
          checkoutController.fetchCheckout();
        },
        builder: (controller) {
          if (controller.checkouts.isEmpty) {
            return const Center(
              child: Text('Anda belum memesan apapun!'),
            );
          }
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: checkoutController.checkouts.length,
              itemBuilder: (context, index) {
                const defaultSeller = SellerModel();
                final checkout = checkoutController.checkouts[index];
                final seller = sellerController.seller.firstWhere(
                  (element) => element.id == checkout.sellerId,
                  orElse: () => defaultSeller,
                );
                return OrderHistoryWidget(
                  seller: seller,
                  checkout: checkoutController.checkouts[index],
                );
              },
            );
          }
        },
      ),
    );
  }
}