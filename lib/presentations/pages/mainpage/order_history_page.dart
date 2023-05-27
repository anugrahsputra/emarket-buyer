import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OrderHistoryPage extends StatelessWidget {
  OrderHistoryPage({Key? key}) : super(key: key);

  final CheckoutController checkoutController = Get.put(CheckoutController());
  final SellerController sellerController = Get.put(SellerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        actions: [
          Obx(
            () => GestureDetector(
                onTap: () {
                  checkoutController.sortByDate.toggle();
                  checkoutController.fetchCheckout();
                },
                child: Icon(checkoutController.sortByDate.isTrue
                    ? MdiIcons.sortBoolAscending
                    : MdiIcons.sortBoolDescending)),
          )
        ],
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
            if (checkoutController.sortByDate.isFalse) {
              checkoutController.checkouts
                  .sort((a, b) => a.date.compareTo(b.date));
            } else {
              checkoutController.checkouts
                  .sort((a, b) => b.date.compareTo(a.date));
            }
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
