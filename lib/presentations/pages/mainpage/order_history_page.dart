import 'package:emarket_buyer/models/model.dart';
import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/presentations/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final SellerController sellerController = Get.put(SellerController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pesanan',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
          ),
          actions: [
            Obx(
              () => GestureDetector(
                onTap: () {
                  Get.find<CheckoutController>().sortByDate.toggle();
                  Get.find<CheckoutController>().fetchCheckout();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Get.find<CheckoutController>().sortByDate.isTrue
                        ? MdiIcons.sortBoolDescendingVariant
                        : MdiIcons.sortBoolAscendingVariant,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            TabBar(
              onTap: (index) {
                Get.find<CheckoutController>().showCompleted.value = index == 1;
                Get.find<CheckoutController>().showIncompleted.value =
                    index == 2;
              },
              tabs: const [
                Tab(
                  text: 'Semua',
                ),
                Tab(
                  text: 'Selesai',
                ),
                Tab(
                  text: 'Belum Selesai',
                ),
              ],
            ),
            Expanded(
              child: _listOrders(),
            ),
          ],
        ),
      ),
    );
  }

  _listOrders() {
    return GetX<CheckoutController>(
      init: Get.find<CheckoutController>(),
      builder: (controller) {
        List<CheckoutModel> filteredCheckout =
            controller.checkouts.where((checkout) {
          if (controller.showCompleted.value) {
            return checkout.isDelivered;
          } else if (controller.showIncompleted.value) {
            return !checkout.isDelivered;
          }
          return true;
        }).toList();
        if (filteredCheckout.isEmpty) {
          return const Center(
            child: Text('Anda belum memesan apapun!'),
          );
        }
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (controller.sortByDate.isTrue) {
            filteredCheckout.sort((a, b) => b.date.compareTo(a.date));
          } else {
            filteredCheckout.sort((a, b) => a.date.compareTo(b.date));
          }
          return RefreshIndicator(
            onRefresh: controller.pullToRefresh,
            child: ListView.builder(
              itemCount: filteredCheckout.length,
              itemBuilder: (context, index) {
                const defaultSeller = SellerModel();
                final checkout = filteredCheckout[index];
                final seller = sellerController.sellers.firstWhere(
                  (element) => element.id == checkout.sellerId,
                  orElse: () => defaultSeller,
                );
                return OrderHistoryWidget(
                  seller: seller,
                  checkout: filteredCheckout[index],
                );
              },
            ),
          );
        }
      },
    );
  }
}
