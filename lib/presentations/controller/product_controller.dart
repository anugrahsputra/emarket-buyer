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

  @override
  void dispose() {
    product.close();
    database.dispose();
    super.dispose();
  }
}
