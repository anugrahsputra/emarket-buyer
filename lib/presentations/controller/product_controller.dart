import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:emarket_buyer/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/model.dart';

class ProductController extends GetxController {
  final Database database = Database();
  RxBool loading = false.obs;
  RxBool isGrid = false.obs;

  final product = RxList<Product>([]);
  final productBySeller = RxList<Product>([]);

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  void setLoading(bool value) {
    loading.value = value;
    update();
  }

  void getProducts() async {
    try {
      setLoading(true);
      product.bindStream(database.fetchProducts());
      setLoading(false);
    } catch (e) {
      setLoading(false);
      debugPrint('ProductController.fetchProducts: $e');
    }
  }

  Future<void> getProductsBySeller() async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      setLoading(true);
      productBySeller.bindStream(database.fetchProductsBySellers(id));
    } catch (e) {
      debugPrint('ProductController.getProductsBySeller: $e');
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    product.close();
    database.dispose();
    super.dispose();
  }
}
